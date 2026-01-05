# Distribution Guide

This guide explains how to distribute `bibleverse` through various package managers and installation methods.

## Table of Contents

1. [Standard Installation Paths](#standard-installation-paths)
2. [Publishing to Homebrew](#publishing-to-homebrew)
3. [Publishing to Other Package Managers](#other-package-managers)
4. [GitHub Releases](#github-releases)
5. [Installation Methods Summary](#installation-methods-summary)

## Standard Installation Paths

### Recommended Paths (in order of preference)

1. **`~/.local/bin`** (User-specific, recommended)
   - ✅ No sudo required
   - ✅ User-specific installation
   - ✅ XDG Base Directory compliant
   - ✅ Won't conflict with system packages
   - Usually needs to be added to PATH manually

2. **`/usr/local/bin`** (System-wide, traditional)
   - ✅ System-wide availability
   - ✅ Already in PATH on most systems
   - ⚠️ Requires sudo on first install
   - ✅ Standard location for user-installed software
   - This is where Homebrew installs on Intel Macs

3. **`/opt/homebrew/bin`** (Homebrew on Apple Silicon)
   - ✅ Standard for Homebrew on M1/M2/M3 Macs
   - ✅ Automatically managed by Homebrew
   - ⚠️ Only for Homebrew-managed packages

### Paths to AVOID

- ❌ `/usr/bin` - Reserved for system packages, managed by OS
- ❌ `/bin` - Reserved for essential system binaries
- ❌ `/sbin` - Reserved for system administration binaries

## Publishing to Homebrew

Homebrew is the most popular package manager for macOS and has Linux support. There are two approaches:

### Option 1: Homebrew Core (Ideal, but harder)

Getting into the main Homebrew repository (`homebrew-core`) gives maximum visibility but has strict requirements.

**Requirements:**
- Well-maintained project with active development
- Stable releases (semantic versioning)
- Good documentation
- Passing CI/CD tests
- Notable user base or unique functionality
- No GUI components (CLI only)

**Process:**
1. Ensure your project meets all requirements
2. Submit a pull request to [homebrew-core](https://github.com/Homebrew/homebrew-core)
3. Wait for review (can take weeks)
4. Address feedback from maintainers

**Not recommended for new/small projects initially.**

### Option 2: Personal Homebrew Tap (Recommended)

A "tap" is a third-party Homebrew repository. This is much easier and gives you full control.

#### Step-by-Step Guide

**1. Create a GitHub repository for your tap:**

```bash
# Repository MUST be named: homebrew-<tap-name>
# Example: homebrew-bibleverse
# Full name: YOUR_USERNAME/homebrew-bibleverse
```

**2. Create your project repository:**

```bash
# This is your main project repository
# Example: YOUR_USERNAME/bibleverse
```

**3. Prepare a release:**

```bash
# In your bibleverse repository
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# Create a tarball
git archive --format=tar.gz --prefix=bibleverse-1.0.0/ v1.0.0 > bibleverse-1.0.0.tar.gz

# Calculate SHA256
shasum -a 256 bibleverse-1.0.0.tar.gz
```

**4. Upload the release to GitHub:**
- Go to your repository on GitHub
- Click "Releases" → "Create a new release"
- Upload the tarball
- Copy the download URL

**5. Create the Formula:**

In your `homebrew-bibleverse` repository, create `Formula/bibleverse.rb`:

```ruby
class Bibleverse < Formula
  desc "Simple command-line tool for displaying random Bible verses"
  homepage "https://github.com/YOUR_USERNAME/bibleverse"
  url "https://github.com/YOUR_USERNAME/bibleverse/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "YOUR_ACTUAL_SHA256_HERE"
  license "MIT"

  depends_on "jq"

  def install
    bin.install "bibleverse"
  end

  test do
    assert_match "Display random Bible verses", shell_output("#{bin}/bibleverse -h")
  end
end
```

**6. Test your formula locally:**

```bash
# Install from your tap
brew tap YOUR_USERNAME/bibleverse
brew install bibleverse

# Test it
bibleverse -h

# Uninstall for testing reinstall
brew uninstall bibleverse
```

**7. Users can now install with:**

```bash
brew tap YOUR_USERNAME/bibleverse
brew install bibleverse
```

Or in one command:
```bash
brew install YOUR_USERNAME/bibleverse/bibleverse
```

#### Updating Your Formula

When you release a new version:

```bash
# 1. Create new release tarball
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0
git archive --format=tar.gz --prefix=bibleverse-1.1.0/ v1.1.0 > bibleverse-1.1.0.tar.gz
shasum -a 256 bibleverse-1.1.0.tar.gz

# 2. Update Formula/bibleverse.rb with new version and SHA256

# 3. Commit and push
cd homebrew-bibleverse
git add Formula/bibleverse.rb
git commit -m "Update to version 1.1.0"
git push

# 4. Users update with:
brew update
brew upgrade bibleverse
```

## Other Package Managers

### AUR (Arch User Repository)

For Arch Linux users:

**Create `PKGBUILD`:**

```bash
pkgname=bibleverse
pkgver=1.0.0
pkgrel=1
pkgdesc="Simple command-line tool for displaying random Bible verses"
arch=('any')
url="https://github.com/YOUR_USERNAME/bibleverse"
license=('MIT')
depends=('bash' 'curl' 'jq')
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/YOUR_USERNAME/bibleverse/archive/v${pkgver}.tar.gz")
sha256sums=('YOUR_SHA256_HERE')

package() {
    cd "$srcdir/$pkgname-$pkgver"
    install -Dm755 bibleverse "$pkgdir/usr/bin/bibleverse"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
```

**Submit to AUR:**
1. Create account at https://aur.archlinux.org
2. Submit PKGBUILD following AUR guidelines
3. Users install with: `yay -S bibleverse` or `paru -S bibleverse`

### APT (Debian/Ubuntu)

Creating a `.deb` package is more complex. Consider using:

**Option 1: PPA (Personal Package Archive) for Ubuntu:**
1. Create account on Launchpad
2. Build `.deb` packages
3. Upload to PPA
4. Users add your PPA and install

**Option 2: Direct `.deb` distribution:**
```bash
# Create debian package structure
mkdir -p bibleverse_1.0.0/DEBIAN
mkdir -p bibleverse_1.0.0/usr/local/bin

# Create control file
cat > bibleverse_1.0.0/DEBIAN/control << EOF
Package: bibleverse
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Depends: bash, curl, jq
Maintainer: Your Name <your.email@example.com>
Description: Simple command-line tool for displaying random Bible verses
 A fast, lightweight tool for displaying random Bible verses
 with support for multiple translations and customizable output.
EOF

# Copy binary
cp bibleverse bibleverse_1.0.0/usr/local/bin/

# Build package
dpkg-deb --build bibleverse_1.0.0

# Users install with:
sudo dpkg -i bibleverse_1.0.0.deb
```

### Snap (Universal Linux)

```bash
# Create snapcraft.yaml
name: bibleverse
version: '1.0.0'
summary: Display random Bible verses in your terminal
description: |
  A simple, fast command-line tool for displaying random Bible verses
  with support for 17 translations and customizable colors.

grade: stable
confinement: strict

apps:
  bibleverse:
    command: bibleverse
    plugs: [network]

parts:
  bibleverse:
    plugin: dump
    source: .
    organize:
      bibleverse: bin/bibleverse

# Build and publish
snapcraft
snapcraft upload --release=stable bibleverse_1.0.0_amd64.snap
```

### NPM (Node Package Manager)

While unusual for bash scripts, you can distribute via npm:

```json
{
  "name": "bibleverse-cli",
  "version": "1.0.0",
  "description": "Display random Bible verses in your terminal",
  "bin": {
    "bibleverse": "./bibleverse"
  },
  "scripts": {
    "postinstall": "chmod +x ./bibleverse"
  },
  "keywords": ["bible", "cli", "terminal", "verse"],
  "author": "Your Name",
  "license": "MIT"
}
```

Users install with:
```bash
npm install -g bibleverse-cli
```

## GitHub Releases

Proper GitHub releases are essential for most package managers.

### Creating a Release

**1. Prepare your release:**

```bash
# Ensure everything is committed
git status

# Update version in script if needed
# Commit any final changes

# Create tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

**2. Create release on GitHub:**

- Go to your repository
- Click "Releases" → "Create a new release"
- Select your tag (v1.0.0)
- Title: "Version 1.0.0"
- Description: List features, bug fixes, breaking changes
- Upload artifacts (optional):
  - Source code is automatically included
  - Can upload pre-built binaries if needed

**3. Generate release artifacts:**

```bash
# Create tarball
git archive --format=tar.gz --prefix=bibleverse-1.0.0/ v1.0.0 > bibleverse-1.0.0.tar.gz

# Create zip
git archive --format=zip --prefix=bibleverse-1.0.0/ v1.0.0 > bibleverse-1.0.0.zip

# Generate checksums
shasum -a 256 bibleverse-1.0.0.tar.gz > checksums.txt
shasum -a 256 bibleverse-1.0.0.zip >> checksums.txt
```

## Installation Methods Summary

After publishing, users can install via:

### 1. Homebrew (macOS/Linux)
```bash
brew install YOUR_USERNAME/bibleverse/bibleverse
```

### 2. One-line installer
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/bibleverse/main/install.sh | bash
```

### 3. Manual installation
```bash
curl -o bibleverse https://raw.githubusercontent.com/YOUR_USERNAME/bibleverse/main/bibleverse
chmod +x bibleverse
mv bibleverse ~/.local/bin/
```

### 4. Git clone
```bash
git clone https://github.com/YOUR_USERNAME/bibleverse.git
cd bibleverse
chmod +x bibleverse
ln -s "$(pwd)/bibleverse" ~/.local/bin/bibleverse
```

### 5. Package managers (if published)
```bash
# Arch Linux
yay -S bibleverse

# Ubuntu/Debian (if in PPA)
sudo add-apt-repository ppa:YOUR_USERNAME/bibleverse
sudo apt update
sudo apt install bibleverse

# Snap
sudo snap install bibleverse

# NPM
npm install -g bibleverse-cli
```

## Best Practices

1. **Semantic Versioning**: Use SemVer (MAJOR.MINOR.PATCH)
   - MAJOR: Breaking changes
   - MINOR: New features (backward compatible)
   - PATCH: Bug fixes

2. **Changelog**: Maintain a CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)

3. **CI/CD**: Use GitHub Actions to:
   - Run tests on commits
   - Build and test Homebrew formula
   - Auto-generate release notes
   - Publish to package managers automatically

4. **Documentation**: Keep README.md updated with:
   - Installation instructions for all methods
   - Usage examples
   - Troubleshooting
   - Contributing guidelines

5. **Licensing**: Include LICENSE file and attribution for dependencies
   - Credit bible_api project: https://github.com/seven1m/bible_api

## Recommended Initial Steps

For a new project, follow this order:

1. ✅ Create GitHub repository
2. ✅ Add LICENSE and README.md
3. ✅ Create first release (v1.0.0)
4. ✅ Create install.sh for easy manual installation
5. ✅ Create personal Homebrew tap
6. 🔄 Build user base
7. 🔄 Consider submitting to homebrew-core (once popular)
8. 🔄 Add to other package managers based on demand

---

**Questions?** Open an issue at https://github.com/YOUR_USERNAME/bibleverse/issues
