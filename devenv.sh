#!/usr/bin/env bash

nix-shell --command zsh \
          -p ruby_3_1 \
          rubyPackages_3_1.solargraph bundler \
          mailcatcher nodejs chromedriver ffmpeg
