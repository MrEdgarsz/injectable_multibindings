# Publishing Guide

This guide explains how to publish the `injectable_multibindings` packages to pub.dev.

## Prerequisites

1. A pub.dev account
2. Authorization to publish packages
3. Git repository set up on GitHub

## Steps

### 1. Update Repository URLs

Edit both `pubspec.yaml` files to replace `yourusername` with your actual GitHub username:

```yaml
homepage: https://github.com/YOUR_USERNAME/injectable_multibindings
repository: https://github.com/YOUR_USERNAME/injectable_multibindings
```

### 2. Create Git Repository

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/injectable_multibindings.git
git push -u origin main
```

### 3. Update Changelog Dates

Edit the CHANGELOG.md files to set the actual release date:

```markdown
## [1.0.0] - 2024-01-15
```

### 4. Verify Package Metadata

Run pub publish --dry-run on both packages:

```bash
cd injectable_multibindings
dart pub publish --dry-run

cd ../injectable_multibindings_generator
dart pub publish --dry-run
```

Fix any issues reported.

### 5. Publish the Main Package

```bash
cd injectable_multibindings
dart pub publish
```

### 6. Update Generator Dependency

Edit `injectable_multibindings_generator/pubspec.yaml`:

```yaml
dependencies:
  injectable_multibindings: ^1.0.0  # Use published version
```

Remove the path dependency and use the published version instead.

### 7. Publish the Generator Package

```bash
cd injectable_multibindings_generator
dart pub publish
```

## Post-Publishing

1. Create a GitHub release with the version tag
2. Add the release notes from CHANGELOG.md
3. Share the packages with the community

## Updating Later

For future releases:

1. Update version in both `pubspec.yaml` files
2. Add new section to CHANGELOG.md
3. Commit and tag the release
4. Publish both packages
5. Create GitHub release

