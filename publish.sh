#!/bin/bash

# World TLDR Publishing Script
# Archives current version and publishes new files

# set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}World TLDR Publishing Script${NC}"
echo "=================================="

# Function to extract YYMM from filename
extract_yymm() {
    local filename="$1"
    if [[ $filename =~ world-tldr-([0-9]{4}) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo ""
    fi
}

# Step 1: Archive current version if it exists
if [ -d "current" ] && [ "$(ls -A current)" ]; then
    echo -e "${YELLOW}Step 1: Archiving current version...${NC}"
    
    # Find the current YYMM from files in current/
    current_file=$(ls current/world-tldr-*.md 2>/dev/null | head -1)
    if [ -n "$current_file" ]; then
        yymm=$(extract_yymm "$(basename "$current_file")")
        if [ -n "$yymm" ]; then
            archive_dir="archive/$yymm"
            mkdir -p "$archive_dir"
            
            # Move current files to archive
            mv current/* "$archive_dir/"
            echo "  ✓ Archived to $archive_dir"
            
            # Save commit hash for this version (if git repo exists)
            if git rev-parse HEAD >/dev/null 2>&1; then
                git rev-parse HEAD > "$archive_dir/commit-hash.txt"
                echo "  ✓ Saved commit hash"
            else
                echo "  ! No git repo yet, skipping commit hash"
            fi
        else
            echo "  ! Could not extract YYMM from filename, skipping archive"
        fi
    else
        echo "  ! No world-tldr files found in current/, skipping archive"
    fi
else
    echo -e "${YELLOW}Step 1: No current version to archive${NC}"
fi

# Step 2: Move root files to current/
echo -e "${YELLOW}Step 2: Moving root files to current/...${NC}"

moved_files=0
# Move digest files
for file in world-tldr-*.md; do
    echo "$file"
    if [ -f "$file" ]; then
        mv "$file" current/
        echo "  ✓ Moved $file to current/"
        ((moved_files++))
    fi
    echo "Outside if"
done

# # Move trends files  
# for file in world-tldr-trends-[0-9][0-9][0-9][0-9].md; do
#     if [ -f "$file" ]; then
#         mv "$file" current/
#         echo "  ✓ Moved $file to current/"
#         ((moved_files++))
#     fi
# done

if [ $moved_files -eq 0 ]; then
    echo "  ! No world-tldr-*.md files found in root directory"
    exit 1
fi

# Step 3: Commit and push
echo -e "${YELLOW}Step 3: Committing and pushing...${NC}"

# Extract date and YYMM from the new files
new_file=$(ls current/world-tldr-*.md 2>/dev/null | head -1)
if [ -n "$new_file" ]; then
    yymm=$(extract_yymm "$(basename "$new_file")")
    current_date=$(date +"%Y-%m-%d")
    
    # Initialize git if not already a repo
    if [ ! -d ".git" ]; then
        echo "  → Initializing git repository..."
        git init
        git branch -M main
    fi
    
    
    # Add all files
    git add .
    
    # Commit with descriptive message
    commit_msg="Publish ${yymm} digest - researched ${current_date}"
    git commit -m "$commit_msg"
    
    # Create tag
    tag_name="v20${yymm:0:2}-${yymm:2:2}"
    git tag "$tag_name"
    
    echo "  ✓ Committed with message: $commit_msg"
    echo "  ✓ Tagged as: $tag_name"
    
    # Push if remote exists
    if git remote get-url origin >/dev/null 2>&1; then
        git push origin main
        git push origin "$tag_name"
        echo "  ✓ Pushed to remote"
        
        # Step 4: Generate permalink
        echo -e "${YELLOW}Step 4: Generating permalink...${NC}"
        commit_hash=$(git rev-parse HEAD)
        remote_url=$(git remote get-url origin)
        
        # Convert SSH to HTTPS if needed
        if [[ $remote_url == git@github.com:* ]]; then
            remote_url=$(echo "$remote_url" | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
        fi
        
        permalink="${remote_url}/blob/${commit_hash}/instructions.md"
        
        echo -e "${GREEN}✓ Publishing complete!${NC}"
        echo ""
        echo "Permalink to instructions for this version:"
        echo "$permalink"
        echo ""
        echo "Raw link (for embedding):"
        echo "${remote_url/github.com/raw.githubusercontent.com}/${commit_hash}/instructions.md"
    else
        echo "  ! No remote configured, skipping push"
        echo -e "${GREEN}✓ Local publishing complete!${NC}"
        echo ""
        echo "Commit hash: $(git rev-parse HEAD)"
        echo "To get permalink, push to remote and use:"
        echo "https://github.com/user/repo/blob/$(git rev-parse HEAD)/instructions.md"
    fi
else
    echo "  ! Could not find new world-tldr file for commit message"
    exit 1
fi