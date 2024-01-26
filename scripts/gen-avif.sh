#!/bin/bash

cd "$(dirname "$0")"
cd ..

quality=65

# Set the directory path
gen_images_dir="resources/_gen/images/"
static_dir="avif/"


# Use a for loop to iterate over the files with the specified naming scheme
for png_file in $(find "$gen_images_dir" -type f -name '*_resize_*.png'); do
    # Extract the directory and filename (without extension) from the PNG file
    relative_dir=$(dirname "${png_file#$gen_images_dir}")
    filename=$(basename "$png_file" .png)

    # Create the AVIF filename by replacing the extension and changing the suffix
    avif_file="$static_dir$relative_dir/${filename//_resize_/_resize_q${quality}_}.avif"

    # Check if the AVIF file already exists at the output path
    if [ -e "$avif_file" ]; then
        echo "AVIF file $avif_file already exists. Skipping conversion for $png_file."
        continue
    fi

    # Create the output directory if it doesn't exist
    mkdir -p "$(dirname "$avif_file")"

    # Call avifenc to convert the PNG to AVIF
    avifenc "$png_file" -o "$avif_file"

    # Output a message indicating the conversion
    echo "Converted $png_file to $avif_file"
done

