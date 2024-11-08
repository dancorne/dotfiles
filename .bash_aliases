# Only useful in a Cygwin environment...
alias c='cd /cygdrive/c/'

# Only useful for lots of Arch systems...
alias upgrade="ansible -m command -a 'pacman -Syu --noconfirm' --sudo -K all"

# Format data for browsing -- good for piping curl to
alias json="python -m json.tool | less"
alias xml="xmllint -format - | less"

# Generates 3 20-character passwords
alias _passwords="LC_ALL=C tr -cd '[:alnum:]' < /dev/urandom | fold -w20 | head -n3"

alias vim="nvim"

alias diff='diff -W $(( $(tput cols) - 2 ))'

alias rg='rg --hidden -g"!{.git,.venv,.terragrunt-cache,vendor/,node_modules/}"'
alias fd='fd -H'

# This assumes we've got dotfiles cloned as a bare repo to $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

_test_jq() {
    echo '' | fzf --print-query --preview "cat $* | jq {q}"
}

alias _clean_terragrunt="find . -type d -name .terragrunt-cache -prune -exec rm -fr {} \+ -delete"

_assume_role() {
    export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
        $(aws-vault exec "${2:-dan}" -- aws sts assume-role \
            --role-arn "$1" \
            --role-session-name MySessionName \
            --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
            --output text
        )
    )
}

# Get all resource types in a directory and search recent AWS provider release notes for changes
_tf_check_release_notes() {
    REGEX="$(rg -INr '$1' '^resource "?(\w+)"? .*' | sort -u | tr '\n' '|')";
    for release in $(gh release list -R hashicorp/terraform-provider-aws | awk '{print $1}'); do
	if gh release view -R hashicorp/terraform-provider-aws $release | rg "resource/(${REGEX%?}):"; then
	    echo $release;
	fi;
    done
}

_terragrunt_use_local_modules() {
    gsed -ri 's^source.*\.git//([a-zA-Z/-]+)\?ref=.*^source = "/Users/dancorne/code/infrastructure-modules//\1"^' $(fd terragrunt.hcl)
}

_terragrunt_change_version() {
    gsed -ri 's^git::git@github.com:'$1'.git//modules/([a-zA-Z/-]+)\?ref=.*^git::git@github.com:'$1'.git//modules/\1?ref='$2'"^' $(fd terragrunt.hcl)
}

