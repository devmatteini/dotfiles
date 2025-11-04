#!/usr/bin/env bash

if ! command -v mise > /dev/null; then
  echo "mise is required to run this script"
  exit 1
fi

mise install java@24
mise install maven@3.9

mise use -g java@24
mise use -g maven@3.9
