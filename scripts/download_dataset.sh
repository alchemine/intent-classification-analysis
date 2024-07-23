#!/bin/bash

# Download aihubshell
curl -o "aihubshell" https://api.aihub.or.kr/api/aihubshell.do
chmod +x aihubshell
sudo cp aihubshell /usr/bin
rm aihubshell

# Download selected dataset (shopping)
mkdir data && cd data
DATASETKEY=544
FILEKEYS=(32759 32763 32767 32771)
for filekey in ${FILEKEYS[@]};
do
    aihubshell -mode d -datasetkey $DATASETKEY -filekey $filekey
done

# Unzip the downloaded dataset
INPUT_DIR=021.용도별_목적대화_데이터

INPUT_FILE=021.용도별_목적대화_데이터/01.데이터/1.Training/라벨링데이터/TL_1.shopping.zip
OUTPUT_DIR=training/label
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

INPUT_FILE=021.용도별_목적대화_데이터/01.데이터/1.Training/원천데이터/TS_1.shopping.zip
OUTPUT_DIR=training/raw
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

INPUT_FILE=021.용도별_목적대화_데이터/01.데이터/2.Validation/라벨링데이터/VL_1.shopping.zip
OUTPUT_DIR=validation/label
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

INPUT_FILE=021.용도별_목적대화_데이터/01.데이터/2.Validation/원천데이터/VS_1.shopping.zip
OUTPUT_DIR=validation/raw
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

# Cleanup the downloaded dataset
rm -rf $INPUT_DIR
