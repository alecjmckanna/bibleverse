# bibleverse

A simple, fast command-line tool for displaying random Bible verses in your terminal.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
  - [Quick Install Script (Recommended)](#quick-install-script-recommended)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Using Different Translations](#using-different-translations)
  - [Using Book Codes](#using-book-codes)
  - [Advanced Examples](#advanced-examples)
- [Available Translations](#available-translations)
- [Customization](#customization)
  - [Custom Colors](#custom-colors)
  - [Integration with Shell Startup](#integration-with-shell-startup)
- [Requirements](#requirements)
- [API](#api)
- [Help & Documentation](#help--documentation)
- [Contributing](#contributing)
  - [Development](#development)
- [License](#license)
  - [Third-Party Licenses](#third-party-licenses)
- [Acknowledgments](#acknowledgments)
- [Roadmap](#roadmap)
- [Support](#support)
- [Author](#author)
- [Version](#version)

## Features

- 📖 **Random Bible verses** from any book or testament
- 🎨 **Customizable colors** via environment variables
- 🌍 **17 translations** including KJV, WEB, ASV, and 7 non-English versions
- 🔍 **Smart filtering** by Old/New Testament or specific books
- 🚀 **No API key required** - completely free and open
- 💻 **Works offline-first** - simple curl-based implementation
- 🎯 **Fast and lightweight** - pure bash script, minimal dependencies

## Installation

### Quick Install Script (Recommended)

```bash
# One-line install to ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/alecjmckanna/bibleverse/main/install.sh | bash
```

### Manual Installation

1. **Download the script:**

   ```bash
   curl -o bibleverse https://raw.githubusercontent.com/alecjmckanna/bibleverse/main/bibleverse
   chmod +x bibleverse
   ```

2. **Move to a directory in your PATH:**

   ```bash
   # Option 1: User-specific installation (recommended)
   mkdir -p ~/.local/bin
   mv bibleverse ~/.local/bin/

   # Add to PATH in your ~/.zshrc or ~/.bashrc if not already there:
   export PATH="$HOME/.local/bin:$PATH"

   # Option 2: System-wide installation (requires sudo)
   sudo mv bibleverse /usr/local/bin/
   ```

3. **Reload your shell:**
   ```bash
   source ~/.zshrc  # or source ~/.bashrc
   ```

> **Note:** Homebrew and other package manager support may be added in the future.

## Usage

### Basic Usage

```bash
# Get a random verse from anywhere in the Bible
bibleverse

# Get a random verse from the Old Testament
bibleverse -t old

# Get a random verse from the New Testament
bibleverse -t new

# Get a random verse from Psalms
bibleverse -b Psalms

# Get a random verse from John (Gospel)
bibleverse -b John
```

### Using Different Translations

```bash
# Use King James Version
bibleverse -v kjv

# Use American Standard Version for Old Testament
bibleverse -t old -v asv

# List all available translations
bibleverse list translations
```

### Using Book Codes

```bash
# Use 3-letter book codes (faster typing!)
bibleverse -b PSA      # Psalms
bibleverse -b JHN      # John
bibleverse -b 1CO      # 1 Corinthians
bibleverse -b REV      # Revelation

# List all books with their codes
bibleverse list books
```

### Advanced Examples

```bash
# Random verse from Proverbs in KJV
bibleverse -b Proverbs -v kjv

# Random NT verse in King James
bibleverse -t new -v kjv

# Case-insensitive book names
bibleverse -b psalms
bibleverse -b JOHN

# Works with partial matches too
bibleverse -b "1 cor"    # Matches 1 Corinthians
```

## Available Translations

### English (10 versions)

- `web` - World English Bible (default)
- `kjv` - King James Version
- `asv` - American Standard Version (1901)
- `bbe` - Bible in Basic English
- `darby` - Darby Bible
- `dra` - Douay-Rheims 1899
- `ylt` - Young's Literal Translation
- `oeb-us` - Open English Bible (US Edition)
- `oeb-cw` - Open English Bible (Commonwealth)
- `webbe` - World English Bible (British Edition)

### Other Languages (7 versions)

- `cherokee` - Cherokee New Testament
- `cuv` - Chinese Union Version (Traditional)
- `bkr` - Bible kralická (Czech)
- `clementine` - Clementine Latin Vulgate
- `almeida` - João Ferreira de Almeida (Portuguese)
- `rccv` - Romanian Corrected Cornilescu
- `synodal` - Russian Synodal Translation

All translations are **Public Domain** and free to use.

## Customization

### Custom Colors

Set environment variables in your `~/.zshrc` or `~/.bashrc`:

```bash
# Dracula theme example
export BIBLEVERSE_TEXT_COLOR="$(tput setaf 15)"      # White text
export BIBLEVERSE_REF_COLOR="$(tput setaf 13)"       # Purple reference
export BIBLEVERSE_ACCENT_COLOR="$(tput setaf 14)"    # Cyan accents

# Nord theme example
export BIBLEVERSE_TEXT_COLOR="$(tput setaf 7)"       # Light gray
export BIBLEVERSE_REF_COLOR="$(tput setaf 12)"       # Frost blue
export BIBLEVERSE_ACCENT_COLOR="$(tput setaf 14)"    # Aurora cyan

# Disable colors
export NO_COLOR=1
```

### Integration with Shell Startup

Add to your `~/.zshrc` to display a random verse on terminal startup:

```bash
# Display random Bible verse on startup
if command -v bibleverse &> /dev/null; then
    bibleverse
fi
```

Or create a more sophisticated version:

```bash
# Display random verse with custom formatting
if command -v bibleverse &> /dev/null; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    bibleverse -v kjv  # Use your preferred translation
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi
```

## Requirements

- **bash** 4.0+ (for associative arrays)
- **curl** - for API requests
- **jq** - for JSON parsing
- **tput** (optional) - for colors

### Installing Dependencies

**macOS (Homebrew):**

```bash
brew install jq
# curl and bash are pre-installed
```

**Ubuntu/Debian:**

```bash
sudo apt-get install jq curl
```

**Fedora/RHEL:**

```bash
sudo dnf install jq curl
```

## API

This tool uses the [bible_api](https://github.com/seven1m/bible_api) project by Tim Morgan, available at [bible-api.com](https://bible-api.com):

- ✅ **Free and open source** - no API key required
- ✅ **No rate limits** for reasonable use (15 requests per 30 seconds)
- ✅ **Public Domain translations** - all 17 versions are freely available
- ✅ **Well-maintained** - reliable uptime and active development
- ✅ **Open source** - MIT licensed, community-driven

## Help & Documentation

```bash
# Show full help
bibleverse -h

# List all available translations
bibleverse list translations

# List all Bible books with codes
bibleverse list books
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development

```bash
# Clone the repository
git clone https://github.com/alecjmckanna/bibleverse.git
cd bibleverse

# Make changes to the bibleverse script
# Test your changes
./bibleverse -t old

# Run with custom colors for testing
BIBLEVERSE_TEXT_COLOR="$(tput setaf 2)" ./bibleverse
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses

- **bible-api.com API**: Free to use, no license required
- **Bible Translations**: All 17 available translations are in the Public Domain

## Acknowledgments

- [bible_api](https://github.com/seven1m/bible_api) by Tim Morgan - Free and open source Bible API
- [bible-api.com](https://bible-api.com) - API service endpoint
- [World English Bible](https://worldenglish.bible/) - Default translation
- All contributors to Public Domain Bible translations

## Roadmap

- [ ] Package manager support (Homebrew, APT, etc.)
- [ ] Support for verse of the day
- [ ] Offline mode with cached verses
- [ ] Search functionality
- [ ] Custom verse collections/favorites
- [ ] Man page documentation
- [ ] Shell completion (bash/zsh)

## Support

- 🐛 **Bug reports**: [GitHub Issues](https://github.com/alecjmckanna/bibleverse/issues)
- 💬 **Questions**: [GitHub Discussions](https://github.com/alecjmckanna/bibleverse/discussions)
- ⭐ **Star the repo** if you find it useful!

## Author

Created by [Alec McKanna](https://github.com/alecjmckanna)

## Version

Current version: 1.1.0

---

**Made with ❤️ for terminal enthusiasts and Bible readers**
