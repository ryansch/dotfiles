#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../script/tea-login"
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "$HOME"
  unset DOTFILES_TEA_ASSUME_TTY DOTFILES_FLOX_REEXEC DISPLAY SSH_TTY
  # Headless Linux box reached over SSH.
  export OSTYPE=linux-gnu
  export SSH_CONNECTION="10.0.0.1 50000 10.0.0.2 22"

  # Fake tea: no existing logins; records `login add` args one per line.
  export TEA_LOG="${BATS_TEST_TMPDIR}/tea-calls"
  export FAKE_OAUTH_STATUS=0
  local bin="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "$bin"
  cat >"${bin}/tea" <<'SH'
#!/usr/bin/env bash
if [[ "$1 $2" == "login add" ]]; then
  echo "$*" >>"$TEA_LOG"
  for arg in "$@"; do
    [[ "$arg" == --oauth ]] && exit "$FAKE_OAUTH_STATUS"
  done
fi
exit 0
SH
  chmod +x "${bin}/tea"
  export PATH="${bin}:${PATH}"
}

@test "skips with exit 0 when stdin is not a TTY" {
  run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [[ "$output" == *"No TTY"* ]]
  [ ! -e "$TEA_LOG" ]
}

@test "SSH session, browser choice runs tea OAuth with the forwarded redirect" {
  export DOTFILES_TEA_ASSUME_TTY=1
  run "$SCRIPT" <<<$'b\n'
  [ "$status" -eq 0 ]
  [[ "$output" == *"-L 53682:127.0.0.1:53682"* ]]
  [ "$(wc -l <"$TEA_LOG")" -eq 1 ]
  grep -qx -- "login add --name git.ryansch.net --url https://git.ryansch.net --oauth --redirect-url http://127.0.0.1:53682/" "$TEA_LOG"
}

@test "SSH session, empty choice defaults to browser login" {
  export DOTFILES_TEA_ASSUME_TTY=1
  run "$SCRIPT" <<<$'\n'
  [ "$status" -eq 0 ]
  grep -q -- "--oauth --redirect-url http://127.0.0.1:53682/" "$TEA_LOG"
}

@test "SSH session, token choice adds login with the pasted token" {
  export DOTFILES_TEA_ASSUME_TTY=1
  run "$SCRIPT" <<<$'t\nsecret123'
  [ "$status" -eq 0 ]
  [ "$(wc -l <"$TEA_LOG")" -eq 1 ]
  grep -qx -- "login add --name git.ryansch.net --url https://git.ryansch.net --token secret123" "$TEA_LOG"
}

@test "failed browser login falls back to the token prompt" {
  export DOTFILES_TEA_ASSUME_TTY=1
  export FAKE_OAUTH_STATUS=1
  run "$SCRIPT" <<<$'b\n\nsecret123'
  [ "$status" -eq 0 ]
  [[ "$output" == *"falling back to an access token"* ]]
  [ "$(wc -l <"$TEA_LOG")" -eq 2 ]
  grep -q -- "--oauth" "$TEA_LOG"
  grep -qx -- "login add --name git.ryansch.net --url https://git.ryansch.net --token secret123" "$TEA_LOG"
}

@test "token choice with empty token skips with exit 0" {
  export DOTFILES_TEA_ASSUME_TTY=1
  run "$SCRIPT" <<<$'t\n'
  [ "$status" -eq 0 ]
  [[ "$output" == *"No token entered"* ]]
  [ ! -e "$TEA_LOG" ]
}
