#!/usr/bin/env bash
set -euo pipefail

echo "Starting Netlify build for Flutter web..."

# install Flutter to $HOME/flutter if not already present
if [ ! -d "$HOME/flutter/bin" ]; then
  echo "Installing Flutter SDK..."
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$HOME/flutter"
else
  echo "Flutter already installed in $HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

echo "Flutter version:"
flutter --version

echo "Enabling web support..."
flutter config --enable-web
flutter precache --web

# make sure pub packages are available
echo "Getting packages..."
flutter pub get

# build web with verbose output
echo "Building Flutter web release..."
flutter build web --release --verbose

echo "Build artifacts:"
ls -la build/web/ | head -20

echo "Build completed successfully!"

