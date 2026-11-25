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

# Fake flox that records its args and runs the command after `--` with a
# fake tea on PATH, standing in for `flox activate -d "$HOME" -- ...`.
setup_fake_flox() {
  unset DOTFILES_FLOX_REEXEC
  export FLOX_ARGS="${BATS_TEST_TMPDIR}/flox-args"
  export FAKE_TEA_DIR="${BATS_TEST_TMPDIR}/tea-bin"
  local flox_dir="${BATS_TEST_TMPDIR}/flox-bin"
  mkdir -p "$FAKE_TEA_DIR" "$flox_dir" "${HOME}/.flox"
  printf '#!/usr/bin/env bash\nexit 0\n' >"${FAKE_TEA_DIR}/tea"
  cat >"${flox_dir}/flox" <<'SH'
#!/usr/bin/env bash
echo "$*" >>"$FLOX_ARGS"
while [[ $# -gt 0 && "$1" != -- ]]; do shift; done
shift
PATH="${FAKE_TEA_DIR}:${PATH}" exec "$@"
SH
  chmod +x "${FAKE_TEA_DIR}/tea" "${flox_dir}/flox"

  # PATH without tea: only bash plus the fake flox.
  local bin="${BATS_TEST_TMPDIR}/restricted-bin"
  mkdir -p "$bin"
  ln -sf "$(command -v bash)" "${bin}/bash"
  RESTRICTED_PATH="${bin}:${flox_dir}"
}

@test "re-execs under flox activate when tea is missing" {
  setup_fake_flox
  PATH="$RESTRICTED_PATH" run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ "$(cat "$FLOX_ARGS")" = "activate -d ${HOME} -- ${SCRIPT}" ]
  [[ "$output" == *"skipping private dotfiles"* ]]
}

@test "does not re-exec again when DOTFILES_FLOX_REEXEC is set" {
  setup_fake_flox
  DOTFILES_FLOX_REEXEC=1 PATH="$RESTRICTED_PATH" run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ ! -e "$FLOX_ARGS" ]
  [[ "$output" == *"skipping private dotfiles"* ]]
}

@test "does not re-exec when there is no default flox env" {
  setup_fake_flox
  rmdir "${HOME}/.flox"
  PATH="$RESTRICTED_PATH" run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ ! -e "$FLOX_ARGS" ]
}

@test "does not re-exec when tea is already on PATH" {
  setup_fake_flox
  PATH="${FAKE_TEA_DIR}:${RESTRICTED_PATH}" run "$SCRIPT" </dev/null
  [ "$status" -eq 0 ]
  [ ! -e "$FLOX_ARGS" ]
}
