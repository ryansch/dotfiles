#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../script/private-bootstrap"
  export HOME="${BATS_TEST_TMPDIR}/home"
  mkdir -p "$HOME"
  export MARKER="${BATS_TEST_TMPDIR}/installed"
  export DOTFILES_PRIVATE_DIR="${HOME}/.dotfiles-private"
  unset DOTFILES_PRIVATE_ASSUME_TTY

  # Local bare repo standing in for the Gitea private repo.
  local src="${BATS_TEST_TMPDIR}/src"
  git init -q "$src"
  cat >"${src}/install" <<'SH'
#!/usr/bin/env bash
touch "$MARKER"
SH
  chmod +x "${src}/install"
  git -C "$src" add install
  git -C "$src" -c user.name=t -c user.email=t@example.com commit -q -m init
  export DOTFILES_PRIVATE_URL="${BATS_TEST_TMPDIR}/remote.git"
  git clone -q --bare "$src" "$DOTFILES_PRIVATE_URL"
}

@test "runs existing private install without prompting" {
  git clone -q "$DOTFILES_PRIVATE_URL" "$DOTFILES_PRIVATE_DIR"
  run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ -f "$MARKER" ]
  [[ "$output" != *Clone* ]]
}

@test "skips quietly when stdin is not a TTY and dir missing" {
  run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ ! -e "$DOTFILES_PRIVATE_DIR" ]
  [[ "$output" == *"skipping private dotfiles"* ]]
}

@test "clones and installs when user answers y" {
  export DOTFILES_PRIVATE_ASSUME_TTY=1
  run "$SCRIPT" <<<"y"
  [ "$status" -eq 0 ]
  [ -d "${DOTFILES_PRIVATE_DIR}/.git" ]
  [ -f "$MARKER" ]
}

@test "does nothing when user answers n" {
  export DOTFILES_PRIVATE_ASSUME_TTY=1
  run "$SCRIPT" <<<"n"
  [ "$status" -eq 0 ]
  [ ! -e "$DOTFILES_PRIVATE_DIR" ]
  [ ! -e "$MARKER" ]
}

@test "does nothing on empty answer" {
  export DOTFILES_PRIVATE_ASSUME_TTY=1
  run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ ! -e "$DOTFILES_PRIVATE_DIR" ]
}
