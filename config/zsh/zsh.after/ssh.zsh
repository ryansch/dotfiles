if [[ "$(ssh-add -l)" == "The agent has no identities." ]]; then

  # Default ssh keys
  potential_keys=(
    ~/.ssh/id_dsa
    ~/.ssh/id_ecdsa
    ~/.ssh/id_ecdsa_sk
    ~/.ssh/id_ed25519
    ~/.ssh/id_ed25519_sk
    ~/.ssh/id_rsa
  )

  # Personal additions
  potential_keys+=(
    ~/.ssh/heroku
    ~/.ssh/gh_ryansch
  )

  keys=()

  for key in "${potential_keys[@]}"; do
    if [[ -f "$key" ]]; then
      keys+=("$key")
    fi
  done

  echo "ssh-add ${keys[@]}"
  ssh-add "${keys[@]}"
fi
