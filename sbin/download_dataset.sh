#!/bin/bash
# -*- coding: utf-8 -*-

# Download aihubshell
curl -o "aihubshell" https://api.aihub.or.kr/api/aihubshell.do
chmod +x aihubshell
cp aihubshell /usr/bin
rm aihubshell

# Download selected dataset (shopping)
mkdir data
DATASETKEY=544
FILEKEYS=(32759 32763 32767 32771)
for filekey in ${FILEKEYS[@]};
do
    aihubshell -mode d -datasetkey $DATASETKEY -filekey $filekey
done

# Unzip the downloaded dataset
INPUT_DIR=021.용도별_목적대화_데이터

INPUT_FILE=$INPUT_DIR/01.데이터/1.Training/라벨링데이터/TL_1.shopping.zip
OUTPUT_DIR=data/training/label
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

INPUT_FILE=$INPUT_DIR/01.데이터/1.Training/원천데이터/TS_1.shopping.zip
OUTPUT_DIR=data/training/raw
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

INPUT_FILE=$INPUT_DIR/01.데이터/2.Validation/라벨링데이터/VL_1.shopping.zip
OUTPUT_DIR=data/validation/label
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

INPUT_FILE=$INPUT_DIR/01.데이터/2.Validation/원천데이터/VS_1.shopping.zip
OUTPUT_DIR=data/validation/raw
mkdir -p $OUTPUT_DIR
unzip $INPUT_FILE -d $OUTPUT_DIR

# Cleanup the downloaded dataset
rm -rf $INPUT_DIR



BASE_PATH=data

old_folder_names=("05.환불반품교환" "03.주문결제" "04.배송")
new_folder_names=("exchange_returnorder" "order_payment" "shipment")

length=${#old_folder_names[@]}
for ((i=0; i<$length; i++)); do
  old_name=${old_folder_names[$i]}
  new_name=${new_folder_names[$i]}
  mv "$BASE_PATH/validation/label/$old_name" "$BASE_PATH/validation/label/$new_name"
  mv "$BASE_PATH/training/label/$old_name" "$BASE_PATH/training/label/$new_name"
  
  mv "$BASE_PATH/validation/raw/$old_name" "$BASE_PATH/validation/raw/$new_name"
  mv "$BASE_PATH/training/raw/$old_name" "$BASE_PATH/training/raw/$new_name"
done


