# Lazy resolver for the RWX Captain access token.
#
# Looks up the 1Password item tagged `rwx-token` in the detaso account and
# exports the password field as RWX_ACCESS_TOKEN for the current shell. The
# lookup happens on first use (typically the captain opencode skill calling
# curl), not on shell start, so TouchID isn't prompted for every new pane.
#
# Usage:
#   RWX_ACCESS_TOKEN=$(rwx_token) curl -H "Authorization: Bearer $RWX_ACCESS_TOKEN" ...
rwx_token() {
  if [[ -z "$RWX_ACCESS_TOKEN" ]]; then
    local item_id
    item_id=$(op item list --account detaso.1password.com --tags rwx-token --format json 2>/dev/null \
      | jq -r 'if length == 1 then .[0].id
               elif length == 0 then "ERR_NONE"
               else "ERR_MANY" end')
    case "$item_id" in
      ERR_NONE)
        print -u2 "rwx_token: no 1Password item tagged 'rwx-token' in detaso account"
        return 1
        ;;
      ERR_MANY)
        print -u2 "rwx_token: multiple 1Password items tagged 'rwx-token'; tag exactly one"
        return 1
        ;;
      "")
        print -u2 "rwx_token: failed to query 1Password (is 'op' signed in?)"
        return 1
        ;;
    esac
    export RWX_ACCESS_TOKEN="$(op item get "$item_id" --account detaso.1password.com --fields password --reveal 2>/dev/null)"
    if [[ -z "$RWX_ACCESS_TOKEN" ]]; then
      print -u2 "rwx_token: 1Password returned an empty password field"
      unset RWX_ACCESS_TOKEN
      return 1
    fi
  fi
  print -r -- "$RWX_ACCESS_TOKEN"
}
