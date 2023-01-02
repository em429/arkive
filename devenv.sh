#!/usr/bin/env bash

nix-shell --command zsh \
          -p ruby bundler mailcatcher nodejs chromedriver
