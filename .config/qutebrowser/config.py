# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Uncomment this to still load settings configured via autoconfig.yml
config.load_autoconfig()

# Always restore open sites when qutebrowser is reopened.
# Type: Bool
c.auto_save.session = False

# Which cookies to accept.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
c.content.cookies.accept = "no-3rdparty"

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value.
# Type: FormatString
config.set("content.headers.user_agent", "Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0")
# c.content.headers.custom = {}


# Open new tabs (middleclick/ctrl+click) in the background.
# Type: Bool
c.tabs.background = True

# Position of the tab bar.
# Type: Position
# Valid values:
#   - top
#   - bottom
#   - left
#   - right
c.tabs.position = "left"

# Search engines which can be used via the address bar. Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` signs. The search engine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
# Type: Dict
c.url.searchengines = {
    "DEFAULT": "https://www.ecosia.org/search?q={}",
    "!ddg": "https://duckduckgo.com/?q={}",
    "!imdb": "https://www.imdb.com/find?s=all&q={}",
    "!g": "https://www.google.com/search?hl=en&q={}",
    "!w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "!qw": "https://www.qwant.com/?q={}",
    "!github": "https://github.com/search?q={}&type=Repositories&l=&l=",
    "!tf": "https://registry.terraform.io/search/modules?q={}",
    "!hn": "https://hn.algolia.com/?q={}",
    "!r": "https://www.reddit.com/search?q={}",
    "!wa": "https://www.wolframalpha.com/input/?i={}",
    "!rt": "https://www.rottentomatoes.com/search?search={}",
    "!kobo": "https://www.kobo.com/gb/en/search?fcmedia=Book&query={}",
    "!youtube": "https://www.youtube.com/results?search_query={}",
}

# Page(s) to open at the start.
# Type: List of FuzzyUrl, or FuzzyUrl
c.url.start_pages = "https://start.duckduckgo.com"

# Don't automatically play media
config.set("content.autoplay", False)

# No location tracking please
config.set("content.geolocation", False)

# Shut up please
config.set("content.notifications.enabled", False)
# Except you, Telegram
config.set("content.notifications.enabled", True, "https://web.telegram.org")

# Stop asking me to handle my emails, GMail
config.set("content.register_protocol_handler", False)

# Default to javascript off, and add `gj` keybinding to allow it per-domain
config.set("content.javascript.enabled", False)
config.bind("gj", "set --pattern *.{url:host} content.javascript.enabled yes ;; set --pattern *.{url:host} content.javascript.can_access_clipboard yes")
config.bind("gJ", "set --pattern *.{url:host} content.javascript.enabled no ;; set --pattern *.{url:host} content.javascript.can_access_clipboard no")

# Keybindings to send URL places
config.bind("sw", "spawn --userscript ~/bin/send_to_wallabag.py")
config.bind("Sw", "hint --rapid links userscript ~/bin/send_to_wallabag.py")
