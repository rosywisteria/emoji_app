import torch
import torch.nn as nn
from torch.utils.data import DataLoader
import torch.optim as optim
import pandas as pd
import random
import numpy as np

import nltk
nltk.download('words')
from nltk.corpus import words
english_words = words.words()

from sentence_transformers import SentenceTransformer, InputExample,losses
from sentence_transformers.util import cos_sim
from sentence_transformers.losses import ContrastiveLoss
from sklearn.preprocessing import normalize
from transformers import pipeline
import emoji

#Functions...
def emoji_to_word(sequence):
    text = emoji.demojize(sequence)
    text = text.replace(":", " ").replace("_", " ") #make colons and underscores spaces
    text = " ".join(text.split())
    return text

def compute_similarity(emoji_seq, guess):
# similarity scores (0-1) for an emoji sequence
    if not guess or len(guess.strip()) < 2:
        return 0.0

    emoji_emb = model.encode(emoji_to_word(emoji_seq))
    guess_emb = model.encode(guess)
    
    epsilon=1e-10 #used to avoid zero division
    emoji_emb /= np.linalg.norm(emoji_emb) + epsilon
    guess_emb /= np.linalg.norm(guess_emb) + epsilon
    
    return np.clip((np.dot(emoji_emb, guess_emb) + 1) / 2, 0.0, 1.0) #rescale to [0,1], use clip for preventing NaN etc
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# csv = pd.read_csv("emoji_puzzles.csv")
# train=[]

# pretrained sentence transformer model
# model = SentenceTransformer('all-MiniLM-L6-v2')
# model = SentenceTransformer('all-mpnet-base-v2')#possibly better performance
# model = SentenceTransformer('emoji_siamese_model_v2')
# model = SentenceTransformer('emoji_siamese_model_v2_finetuned')
model = SentenceTransformer('emoji_siamese_model_v3_finetuned')


# for _, row in csv.iterrows():
#     emoji_text = emoji_to_word(row['emojis'])
#     answer= row['answer']

#     train.append(InputExample(texts=[emoji_text, answer], label=1.0))

#     answers = [a for a in csv["answer"].tolist() if a != answer]
#     negative_words = random.sample(answers, 10) #5 random negative words to counter correct data
#     negative_words = random.sample([w for w in english_words if w.lower() != answer.lower()], 10)
#     for n in negative_words:
#         train.append(InputExample(texts=[emoji_text, n], label=0.0))
    
# # # DataLoader
# train_dataloader = DataLoader(train, shuffle=True, batch_size=16)
# train_loss = ContrastiveLoss(model)

# model.fit(
#     train_objectives=[(train_dataloader, train_loss)],
#     epochs=5,          # increase to 2-3 if you have time
#     warmup_steps=10,
#     show_progress_bar=True
# )

# Save the fine-tuned model
# model.save("emoji_siamese_model_v3_finetuned")

# -----------------------------
# 8. Test the trained model
# -----------------------------
# data = [
#     ("⚡🧙‍♂️","Harry Potter"),
#     ("👨‍🍳🤌","Chef"),
#     ("🍎📱","iPhone"),
#     ("🦁👑🎥","Lion King"),
#     ("🎃👻","Halloween"),
#     ("🎄🎁","Christmas"),
#     ("💍👰","wedding"),
#     ("🎓🎉","graduation"),
#     ("🎮🖥️","gaming"),
#     ("🐰👮‍♀️🦊🌆🥕🫐","Zootopia"),
#     ("🟡👖😎🍌🌕","Minions"),
#     ("🦖🌋🏞️","Jurassic Park"),
#     ("🚢❄️💔🎶🎥","Titanic"),
#     ("👩‍🚀🚀🌌🎬","Interstellar"),
#     ("👸❄️👑⛄🎶","Frozen"),
#     ("🐉🔥⚔️👑","Game of Thrones"),
#     ("🦸‍♂️🦸‍♀️⚡💥📺","The Boys"),
#     ("🎤🕺✨👑","Michael Jackson"),
#     ("🦸‍♂️🕷️🕸️🏙️","Spider-Man"),
#     ("🧙‍♂️💍🏔️","Lord of the Rings"),
#     ("🏎️🔥🏁","F1"),
#     ("🎤🎸👨‍🎤","Elvis Presley"),
#     ("🛳️❄️💔","Titanic"),
#     ("👨‍🚒🔥🏠","Firefighter"),
#     ("🐼🥋","Kung Fu Panda"),
#     ("🦇🕷️🦸‍♂️","Batman"),
#     ("🧞‍♀️🕌🧞‍♂️","Aladdin")
# ]


# # random guesses
# guesses = ["Harry Potter","Hogwarts","Chef","Pizza","iPhone","Android",
#            "Lion King","Frozen","Game of Thrones","The Boys","F1","Elvis Presley",
#            "Titanic","Firefighter","Kung Fu Panda","Batman","Aladdin","Panda","car","man",
#            "wonder woman", "the girls", "ship","heart","cat","dog","clothes","floor"]

# # Iterate through the emoji sequences
# for emoji_seq, actual_answer in data:
#     print(f"\nEmoji sequence: {emoji_seq}")
#     print(f"Actual answer: {actual_answer}")

#     # Compute similarity for each guess individually
#     scores = {guess: compute_similarity(emoji_seq, guess) for guess in guesses}

#     # Sort guesses by similarity (high → low)
#     sorted_scores = dict(sorted(scores.items(), key=lambda item: item[1], reverse=True))

#     print("Similarity scores (0–1):")
#     for g, s in sorted_scores.items():
#         print(f"{g}: {s:.3f}")
