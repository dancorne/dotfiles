#!/usr/bin/env python3
import os
import requests
import tempfile
from datetime import datetime, timezone
# Need to install rmapy, probably doesn't matter what version
# Also need to have logged in with a CLI client (rmapy or rmapi)
from rmapy.api import Client
from rmapy.document import ZipDocument
from rmapy.folder import Folder
from rmapy.const import RFC3339Nano

WALLABAG_BASE_URL = os.environ.get("WALLABAG_BASE_URL", "https://app.wallabag.it")
# These folders need to exist on Remarkable beforehand
UNREAD_FOLDER = "wallabag"
ARCHIVE_FOLDER = "archive"
FAVOURITES_FOLDER = "favourites"


class Wallabag(requests.Session):
    def wallabagLogin(self):
        url = f"{WALLABAG_BASE_URL}/oauth/v2/token"
        data = {
            "grant_type": "password",
            "client_id": os.environ["WALLABAG_CLIENT_ID"],
            "client_secret": os.environ["WALLABAG_CLIENT_SECRET"],
            "username": os.environ["WALLABAG_USERNAME"],
            "password": os.environ["WALLABAG_PASSWORD"],
        }
        response = self.post(url, json=data)
        response.raise_for_status()
        self.token_data = response.json()
        self.headers["Authorization"] = f"Bearer {self.token_data['access_token']}"
        return

    def getEntries(self):
        response = self.get(f"{WALLABAG_BASE_URL}/api/entries.json?detail=metadata")
        response.raise_for_status()
        data = response.json()
        entries = data["_embedded"]["items"]
        while data["_links"].get("next"):
            response = self.get(response.json()["_links"]["next"]["href"])
            response.raise_for_status()
            data = response.json()
            entries.extend(data["_embedded"]["items"])
        return entries

    def export(self, article_id, write_target):
        res = self.get(f"{WALLABAG_BASE_URL}/api/entries/{article_id}/export.epub")
        res.raise_for_status()
        write_target.write(res.content)

    def updateEntry(self, article, archive=None, starred=None):
        data = {}
        if archive is not None:
            data["archive"] = int(archive)
        if starred is not None:
            data["starred"] = int(starred)
        print(data)
        res = self.patch(f"{WALLABAG_BASE_URL}/api/entries/{article['id']}.json", json=data)
        res.raise_for_status()


class Remarkable(Client):
    def update_metadata(self, docorfolder):
        """Overridden the rmapy method so we can specify different modified timestamps."""
        req = docorfolder.to_dict()
        req["Version"] = self.get_current_version(docorfolder) + 1
        res = self.request("PUT", "/document-storage/json/2/upload/update-status", body=[req])
        return self.check_response(res)


def main():
    wallabag = Wallabag()
    wallabag.wallabagLogin()
    rmapy = Remarkable()
    rmapy.renew_token()
    collection = rmapy.get_meta_items()
    titles = set(f.VissibleName for f in collection)
    unread = [f for f in collection if isinstance(f, Folder) and f.VissibleName == UNREAD_FOLDER][0]
    favourites = [f for f in collection if isinstance(f, Folder) and f.VissibleName == FAVOURITES_FOLDER][0]
    archive = [f for f in collection if isinstance(f, Folder) and f.VissibleName == ARCHIVE_FOLDER][0]
    for w in wallabag.getEntries()[:50]:
        title = f"{w['title']} - {w['id']}"
        w_modifiedtime = datetime.strptime(w["updated_at"], "%Y-%m-%dT%H:%M:%S%z")
        if w["is_archived"] == 0:
            target = unread
        elif w["is_starred"] == 1:
            target = favourites
        else:
            target = archive
        if title not in titles:
            with tempfile.NamedTemporaryFile() as f:
                wallabag.export(w["id"], f.file)
                rawDocument = ZipDocument(doc=f.name)
                rawDocument.metadata["VissibleName"] = title
                rawDocument.metadata["ModifiedClient"] = w_modifiedtime.astimezone(tz=timezone.utc).strftime(RFC3339Nano)
                rmapy.upload(rawDocument, target)
                print(f"Uploaded {title} to {target.VissibleName}")
        else:
            rm_doc = [f for f in collection if f.VissibleName == title][0]
            if rm_doc.Parent == target.ID:
                continue
            elif w_modifiedtime >= datetime.strptime(rm_doc.ModifiedClient, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=timezone.utc):
                print(f"{title} in wrong folder and more recent in Wallabag, moving to {target.VissibleName}...")
                rm_doc.Parent = target.ID
                rm_doc.ModifiedClient = w_modifiedtime.astimezone(tz=timezone.utc).strftime(RFC3339Nano)
                rmapy.update_metadata(rm_doc)
            else:
                # Wrong message, should be parents "vissiblename"
                print(f"{title} moved to {target.VissibleName}, updating Wallabag...")
                if rm_doc.Parent == archive.ID:
                    wallabag.updateEntry(w, archive=True, starred=False)
                elif rm_doc.Parent == favourites.ID:
                    wallabag.updateEntry(w, archive=True, starred=True)
                elif rm_doc.Parent == unread.ID:
                    wallabag.updateEntry(w, archive=False)
                else:
                    print("Found some edge case when searching for Wallabag location.")


if __name__ == "__main__":
    main()
