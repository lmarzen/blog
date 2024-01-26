#!/bin/bash
cd "$(dirname "$0")"
cd ../

# clean
# rm -r public
# rm -r resources

hugo
bash scripts/gen-avif.sh

