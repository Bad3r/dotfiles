#!/bin/bash

# GPG Key Generation Script for GitHub Commit Signing
# Uses EdDSA (Ed25519) with modern security standards

set -euo pipefail

# Configuration
EMAIL="Bad3r@users.noreply.github.com"
NAME="Bad3r"
KEY_TYPE="eddsa"
KEY_USAGE="sign"
EXPIRE_DATE="2y"  # 2 years expiration

echo "Generating GPG key for GitHub commit signing..."
echo "Email: $EMAIL"
echo "Name: $NAME"
echo "Key Type: $KEY_TYPE"
echo "Expiration: $EXPIRE_DATE"
echo

# Generate GPG key with batch mode
gpg --batch --full-generate-key <<EOF
Key-Type: $KEY_TYPE
Key-Curve: ed25519
Key-Usage: $KEY_USAGE
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: $EXPIRE_DATE
%no-protection
%commit
EOF

# Get the key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" | grep 'sec' | sed 's/.*ed25519\///g' | sed 's/ .*//g')

echo
echo "GPG key generated successfully!"
echo "Key ID: $KEY_ID"
echo

# Export public key for GitHub
echo "Public key for GitHub (copy this to GitHub Settings > SSH and GPG keys):"
echo "=================================================================="
gpg --armor --export "$KEY_ID"
echo "=================================================================="
echo

# Configure Git to use the GPG key
echo "Configuring Git to use the GPG key..."
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global gpg.program gpg

echo
echo "Git configuration complete!"
echo "Your commits will now be signed automatically."
echo
echo "Next steps:"
echo "1. Copy the public key above to GitHub Settings > SSH and GPG keys"
echo "2. Verify with: git log --show-signature -1"