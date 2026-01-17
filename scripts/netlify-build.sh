#!/usr/bin/env bash
set -euo pipefail

# install Flutter to $HOME/flutter if not already present
if [ ! -d "$HOME/flutter/bin" ]; then
  echo "Installing Flutter SDK..."
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$HOME/flutter"
else
  echo "Flutter already installed in $HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

flutter config --enable-web
flutter precache --web

# make sure pub packages are available
flutter pub get

# build web
flutter build web --release
