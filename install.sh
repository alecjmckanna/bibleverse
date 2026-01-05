#!/usr/bin/env bash
#
# Installation script for bibleverse
# Usage: curl -fsSL https://raw.githubusercontent.com/alecjmckanna/bibleverse/main/install.sh | bash
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation variables
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
REPO_URL="https://raw.githubusercontent.com/alecjmckanna/bibleverse/main/bibleverse"
SCRIPT_NAME="bibleverse"

# Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Main installation function
main() {
    print_message "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$BLUE" "  Installing bibleverse"
    print_message "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo

    # Check dependencies
    print_message "$YELLOW" "Checking dependencies..."

    local missing_deps=()

    if ! command_exists curl; then
        missing_deps+=("curl")
    fi

    if ! command_exists jq; then
        missing_deps+=("jq")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_message "$RED" "Error: Missing required dependencies: ${missing_deps[*]}"
        echo
        print_message "$YELLOW" "Install them with:"

        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "  brew install ${missing_deps[*]}"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command_exists apt-get; then
                echo "  sudo apt-get install ${missing_deps[*]}"
            elif command_exists dnf; then
                echo "  sudo dnf install ${missing_deps[*]}"
            elif command_exists yum; then
                echo "  sudo yum install ${missing_deps[*]}"
            fi
        fi
        exit 1
    fi

    print_message "$GREEN" "✓ All dependencies found"
    echo

    # Create installation directory if it doesn't exist
    print_message "$YELLOW" "Creating installation directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    print_message "$GREEN" "✓ Directory created"
    echo

    # Download the script
    print_message "$YELLOW" "Downloading bibleverse..."
    if curl -fsSL "$REPO_URL" -o "${INSTALL_DIR}/${SCRIPT_NAME}"; then
        print_message "$GREEN" "✓ Downloaded successfully"
    else
        print_message "$RED" "✗ Failed to download bibleverse"
        exit 1
    fi
    echo

    # Make it executable
    print_message "$YELLOW" "Making executable..."
    chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
    print_message "$GREEN" "✓ Script is now executable"
    echo

    # Check if directory is in PATH
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        print_message "$YELLOW" "⚠ Note: $INSTALL_DIR is not in your PATH"
        echo
        print_message "$BLUE" "Add this to your ~/.zshrc or ~/.bashrc:"
        echo
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo
        print_message "$BLUE" "Then reload your shell:"
        echo "  source ~/.zshrc  # or source ~/.bashrc"
        echo
    else
        print_message "$GREEN" "✓ Installation directory is in PATH"
        echo
    fi

    # Success message
    print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$GREEN" "  ✓ Installation complete!"
    print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_message "$BLUE" "Try it out:"
    echo "  bibleverse"
    echo "  bibleverse -h"
    echo "  bibleverse list translations"
    echo
    print_message "$BLUE" "Get a random verse:"
    echo
    "${INSTALL_DIR}/${SCRIPT_NAME}"
}

# Run main function
main "$@"
