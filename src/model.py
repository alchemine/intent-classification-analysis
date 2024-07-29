import torch
from torch import nn

class IntentClassifier(nn.Module):
    def __init__(self, base_model, hidden_size,num_labels=3):
        super(IntentClassifier, self).__init__()
        self.base_model = base_model
        # 분류를 위한 추가 레이어
        self.classifier = nn.Linear(hidden_size, num_labels)
        self.num_labels = num_labels

    def forward(self, input_ids, attention_mask=None, labels=None):
        outputs = self.base_model(input_ids=input_ids, attention_mask=attention_mask)
        logits = self.classifier(outputs.last_hidden_state[:,0,:])

        if labels is not None:
            loss_fn = nn.CrossEntropyLoss()
            loss = loss_fn(logits.view(-1, self.num_labels), labels.view(-1))
            return loss, logits
        return logits
    
