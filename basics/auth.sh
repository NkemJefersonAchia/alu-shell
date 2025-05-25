#!/bin/bash

GITHUB_USERNAME="NkemJefersonAchia"
GITHUB_TOKEN="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"

# Ask for commit message
read -p "Enter commit message: " commit_msg

# Stage all changes
git add .

# Commit with message
git commit -m "$commit_msg"

# Get current remote URL
remote_url=$(git remote get-url origin)

# Modify remote URL to include username and token for HTTPS
# This handles both 'https://' and 'git@github.com:' formats
if [[ $remote_url == https://* ]]; then
    # Insert username:token@ after https://
    auth_remote_url=$(echo "$remote_url" | sed -E "s#https://#https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@#")
elif [[ $remote_url == git@github.com:* ]]; then
    # Convert SSH URL to HTTPS with token
    repo_path=$(echo "$remote_url" | cut -d':' -f2)
    auth_remote_url="https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${repo_path}"
else
    echo "Unsupported remote URL format: $remote_url"
    exit 1
fi

# Push using token-authenticated URL
git push "$auth_remote_url"
