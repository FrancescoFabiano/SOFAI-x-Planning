import pandas as pd
from transformers import RobertaTokenizerFast
import torch

# Initialize the RoBERTa tokenizer
tokenizer = RobertaTokenizerFast.from_pretrained('roberta-base')

# Move the model to the GPU (if available)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

# Define a function to count the number of tokens in a prompt
def count_tokens(prompt):
    return len(tokenizer.encode(prompt))


