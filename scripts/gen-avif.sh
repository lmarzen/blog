#!/bin/bash

AVIFENC=avifenc
if [ "$NETLIFY" = "true" ];
then
    AVIFENC=$(realpath $(dirname "$0")/../.local/bin/avifenc)
fi

cd "$(dirname "$0")"
cd ..

quality=65

# Set the directory path
gen_images_dir="resources/_gen/images"
static_dir="avif"

# Use a for loop to iterate over the files with the specified naming scheme
for png_file in $(find "$gen_images_dir" -type f -name '*.png'); do
    # Extract the directory and filename (without extension) from the PNG file
    relative_dir=$(dirname "${png_file#$gen_images_dir/}")
    filename=$(basename "$png_file" .png)

    # Create the AVIF filename by replacing the extension and changing the suffix
    avif_file="$static_dir/$relative_dir/$filename.avif"

    # Check if the AVIF file already exists at the output path
    if [ -e "$avif_file" ]; then
        echo "AVIF file $avif_file already exists. Skipping conversion for $png_file."
        continue
    fi

    # Create the output directory if it doesn't exist
    mkdir -p "$(dirname "$avif_file")"

    # Call avifenc to convert the PNG to AVIF
    $AVIFENC "$png_file" -o "$avif_file"

    # Output a message indicating the conversion
    echo "Converted $png_file to $avif_file"
done
# export PATH=/opt/buildhome/.yarn/bin:/opt/buildhome/.config/yarn/global/node_modules/.bin:/opt/build/repo/node_modules/.bin:/opt/build/node_modules/.bin:/opt/node_modules/.bin:/node_modules/.bin:/opt/buildhome/.nvm/versions/node/v18.19.0/bin:/opt/buildhome/.nvm/versions/node/v18.19.0/bin:/opt/build/cache/.binrc-a5679f71f5966d1b3450c8dcd52d4743ec08e632/binaries/gohugoio/hugo/v0.122.0:/opt/build/cache/.binrc-a5679f71f5966d1b3450c8dcd52d4743ec08e632/binaries/gohugoio/hugo/v0.122.0:/opt/buildhome/.gimme/versions/go1.19.13.linux.amd64/bin:/opt/buildhome/.rvm/gems/ruby-2.7.2/bin:/opt/buildhome/.rvm/gems/ruby-2.7.2@global/bin:/opt/buildhome/.rvm/rubies/ruby-2.7.2/bin:/opt/buildhome/python3.8/bin:/home/linuxbrew/.linuxbrew/bin:/opt/buildhome/.swiftenv/bin:/opt/buildhome/.swiftenv/shims:/opt/buildhome/.php:/opt/buildhome/.binrc/bin:/opt/buildhome/.bun/bin:/opt/buildhome/.deno/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/buildhome/.cask/bin:/opt/buildhome/.gimme/bin:/opt/buildhome/.dotnet/tools:/opt/buildhome/.dotnet:/opt/buildhome/.cargo/bin:/opt/buildhome/.rvm/bin:/opt/buildhome/.rvm/bin
