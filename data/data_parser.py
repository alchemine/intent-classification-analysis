import os
import json
import datasets
from transformers import ElectraTokenizer
import argparse
from os.path import abspath, dirname, join
    

def get_txt_files(directory):
    txt_files = [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith('.txt')]
    return txt_files


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    DATA_DIR = dirname(abspath(__file__))
    parser.add_argument("--BASE_PATH", default=join(DATA_DIR, "raw"))
    parser.add_argument("--id_info_path", default=join(DATA_DIR, "id.json"))
    parser.add_argument("--tokenizer", default="monologg/koelectra-base-v3-discriminator")
    parser.add_argument("--save_dir", default=join(DATA_DIR, "preprocess"))


    args = parser.parse_args()



    tokenizer = ElectraTokenizer.from_pretrained(args.tokenizer)
    with open(args.id_info_path, "r") as f:
        ids = json.load(f)

    datas = []
    for key in ids.keys():
        text_files = get_txt_files(os.path.join(args.BASE_PATH, key))
        
        for file in text_files:
            with open(file, 'r', encoding='utf-8') as file:
                content = file.read()
                if len(content)<100:
                    continue
                datas.append({"text":content, "label":ids[key]})

    datas = datasets.Dataset.from_list(datas)
    datas = datas.map(lambda example:tokenizer(example['text']))
    datas.save_to_disk(args.save_dir)