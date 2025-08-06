![Objects365](https://www.objects365.org/images/output.jpg)

# Object365 Dataset Downloader

This repository contains a bash script for downloading and setting up the Object365 dataset.

## Prerequisites

Before running the script, you need to have wget installed on your system.

## Usage

1. Clone this repository to your local machine:
```bash
git clone https://github.com/rendicahya/objects365.git
```

2. Change to the repository directory:
```bash
cd objects365
```

3. Make the script executable:
```bash
chmod +x setup.sh
```

4. Run the script:
```bash
./setup.sh path/to/download/directory
```
It will prompt you to choose whether to delete the temporary files used during the process. It is recommended if you have limited storage. After running the script, it will display the number and size of downloaded images for both training and validation sets.

## Dataset Information

The Object365 dataset is a collection of images containing various objects and scenes. It is useful for training object detection models and testing computer vision algorithms.

For more information about the dataset, please visit the [official Object365 website](https://www.objects365.org/).
