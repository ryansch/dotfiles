if [[ "$(ssh-add -l)" == "The agent has no identities." ]]; then

  potential_keys=(
    ~/.ssh/id_dsa
    ~/.ssh/id_ecdsa
    ~/.ssh/id_ecdsa_sk
    ~/.ssh/id_ed25519
    ~/.ssh/id_ed25519_sk
    ~/.ssh/id_rsa
    ~/.ssh/heroku
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
