#!/bin/bash



# Install OpenSSH Server if it's not already installed
install_ssh_server() {
    echo "Installing OpenSSH Server..."
    if [ -x "$(command -v apt-get)" ]; then
        apt-get update
        apt-get install -y openssh-server
    elif [ -x "$(command -v yum)" ]; then
        yum install -y openssh-server
    else
        echo "Unsupported package manager. Install OpenSSH manually."
        exit 1
    fi
}

# Configure SSH to use key-based authentication
configure_ssh() {
    echo "Configuring SSH..."
    SSHD_CONFIG="/etc/ssh/sshd_config"

    # Enable public key authentication
    sed -i '/^PubkeyAuthentication/s/^.*$/PubkeyAuthentication yes/' $SSHD_CONFIG
    if ! grep -q "^PubkeyAuthentication yes" $SSHD_CONFIG; then
        echo "PubkeyAuthentication yes" >> $SSHD_CONFIG
    fi

    # # Disable password authentication
    # sed -i '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' $SSHD_CONFIG
    # if ! grep -q "^PasswordAuthentication no" $SSHD_CONFIG; then
    #     echo "PasswordAuthentication no" >> $SSHD_CONFIG
    # fi

    # # Disable challenge-response authentication
    # sed -i '/^ChallengeResponseAuthentication/s/^.*$/ChallengeResponseAuthentication no/' $SSHD_CONFIG
    # if ! grep -q "^ChallengeResponseAuthentication no" $SSHD_CONFIG; then
    #     echo "ChallengeResponseAuthentication no" >> $SSHD_CONFIG
    # fi
}

# Restart SSH service
restart_ssh() {
    echo "Restarting SSH service..."
    systemctl restart sshd
}

setup_github_key() {
  GITHUB_USERNAME="billxc"
  # Step 1: Fetch GitHub public keys
  echo "Fetching public keys for GitHub user: $GITHUB_USERNAME"
  mkdir -p $HOME/.ssh
  chmod 700 $HOME/.ssh
  curl -s "https://github.com/$GITHUB_USERNAME.keys" >> $HOME/.ssh/authorized_keys

  # Step 2: Ensure permissions are correct
  chmod 600 $HOME/.ssh/authorized_keys
}

# Main execution block
main() {
    # install_ssh_server
    configure_ssh
    # setup_github_key
    restart_ssh
    echo "SSH has been configured for key-based authentication."
}

if [ "$(id -u)" -ne 0 ]; then
    echo "Running as normal user, setup_github_key" >&2
    setup_github_key
    exit 0
fi

main

# Run the main function

