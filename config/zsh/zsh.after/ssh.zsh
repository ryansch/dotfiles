# ssh-add -l exits 0 when the agent has keys, 1 when it is reachable but
# empty, and 2 when there is no agent at all.
_ssh_agent_empty() {
  ssh-add -l >/dev/null 2>&1
  [[ $? -eq 1 ]]
}

_in_ssh_session() {
  [[ -n "$SSH_CONNECTION" ]]
}

# Load keys into a reachable, empty agent. Skip inside ssh sessions: a
# forwarded agent belongs to the client machine, and this host's key files
# shouldn't be pushed into it.
if ! _in_ssh_session && _ssh_agent_empty; then

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

unfunction _ssh_agent_empty _in_ssh_session
