#!/bin/bash

# Function to check if git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Please install Git first."
        exit 1
    fi
}

# Function to check if repository exists
check_repo() {
    if [ ! -d ".git" ]; then
        echo "This is not a git repository. Please run this script in a git repository."
        exit 1
    fi
}

# Function to sync repository
sync_repo() {
    echo "Fetching changes from remote..."
    git fetch origin

    # Get current branch name
    current_branch=$(git branch --show-current)
    
    echo "Current branch: $current_branch"
    
    # Check for local changes
    if [ -n "$(git status --porcelain)" ]; then
        echo "Local changes detected."
        
        # Ask user what to do with local changes
        echo "What would you like to do with local changes?"
        echo "1. Stash changes and pull"
        echo "2. Commit changes and pull"
        echo "3. Force pull (discard local changes)"
        echo "4. Exit"
        read -p "Enter your choice (1-4): " choice
        
        case $choice in
            1)
                echo "Stashing local changes..."
                git stash
                echo "Pulling latest changes..."
                git pull origin $current_branch
                echo "Applying stashed changes..."
                git stash pop
                ;;
            2)
                echo "Enter commit message:"
                read commit_message
                git add .
                git commit -m "$commit_message"
                echo "Pulling latest changes..."
                git pull origin $current_branch
                ;;
            3)
                echo "Discarding local changes and pulling..."
                git reset --hard
                git pull origin $current_branch
                ;;
            4)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice. Exiting..."
                exit 1
                ;;
        esac
    else
        echo "No local changes. Pulling latest changes..."
        git pull origin $current_branch
    fi
    
    # Push changes if any
    echo "Pushing changes to remote..."
    git push origin $current_branch
    
    echo "Repository sync completed!"
}

# Main script
echo "GitHub Repository Sync Script"
echo "----------------------------"

# Check if git is installed
check_git

# Check if this is a git repository
check_repo

# Run sync
sync_repo 