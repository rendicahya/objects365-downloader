#!/bin/bash

echo "Creating the directory structure..."
mkdir -p images
mkdir -p images/train
mkdir -p images/val
mkdir -p images-temp/train
mkdir -p images-temp/val

echo "Downloading train images..."
wget -i images-train.txt -P images-temp/train

echo "Downloading validation images..."
wget -i images-val.txt -P images-temp/val

echo "Extracting train images..."
for file in images-temp/train/*.tar.gz; do
    tar -xzf "$file" -C images/train
done

echo "Extracting validation images..."
for file in images-temp/val/*.tar.gz; do
    tar -xzf "$file" -C images/val
done

echo "Moving train images..."
find images/train -name "*.jpg" -exec mv -t images/train {} +

echo "Moving validation images..."
find images/val -name "*.jpg" -exec mv -t images/val {} +

num_train=$(find images/train -type f -name "*.jpg" | wc -l)
num_val=$(find images/val -type f -name "*.jpg" | wc -l)

size_train=$(du -sh images/train | cut -f 1)
size_val=$(du -sh images/val | cut -f 1)

echo "Downloaded $num_train train images. Total size: $size_train"
echo "Downloaded $num_val val images. Total size: $size_val"

read -p "Do you want to delete the temporary directories? (y/n): " choice

if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
    echo "Deleting the temporary directories..."
    rm -rf images-temp
    echo "Temporary directories deleted."
else
    echo "Temporary directories not deleted."
fi
