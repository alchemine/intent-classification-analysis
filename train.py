from transformers import DataCollatorWithPadding
from transformers import BertTokenizer, BertForSequenceClassification, Trainer, TrainingArguments
import datasets
from transformers import ElectraTokenizer, ElectraModel
from src.model import *
from os.path import abspath, dirname, join

import torch
model_name = "monologg/koelectra-base-v3-discriminator"
tokenizer = ElectraTokenizer.from_pretrained(model_name)
base_model = ElectraModel.from_pretrained(model_name)


FILE_DIR = dirname(abspath(__file__))
tokenized_datasets = datasets.load_from_disk(join(FILE_DIR, "sbin/data/preprocess"))
tokenized_datasets = tokenized_datasets.train_test_split(test_size=0.1, seed=42, shuffle=True)


model = IntentClassifier(base_model, 768)

# 트레이닝 아규먼트 설정
training_args = TrainingArguments(
    output_dir='./results',          # 모델과 체크포인트 저장 경로
    evaluation_strategy="steps",     # 평가 전략 설정
    learning_rate=5e-6,
    per_device_train_batch_size=8,
    per_device_eval_batch_size=16,
    gradient_accumulation_steps=16,
    num_train_epochs=40,
    weight_decay=0.01,
    eval_steps=100,
    logging_dir='./logs',            # 로그 저장 경로
)


# 데이터 콜레이터 정의
data_collator = DataCollatorWithPadding(tokenizer=tokenizer)

# 트레이너 설정
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets['train'],
    eval_dataset=tokenized_datasets['test'],
    data_collator=data_collator,
)

trainer.train()


texts = []
predicts = []
labels = []
acc = 0
# check
for data in tokenized_datasets['test']:
    logits = model(torch.tensor([data['input_ids']]).to('cuda'))
    predict = logits[0].argmax()
    predicts.append(predict)
    labels.append(data['label'])
    texts.append(data['text'])
    if predict==data['label']:
        acc +=1

import pandas as pd
print(acc/len(texts))
pd.DataFrame({"text":texts, "predict":predicts, "label":labels}).to_csv("result.csv", index=False)