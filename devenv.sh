#!/usr/bin/env bash

nix-shell --command zsh \
          -p ruby bundler goreman mailcatcher nodejs chromedriver
