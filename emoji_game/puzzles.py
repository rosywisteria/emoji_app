import pandas as pd
import random
csv = pd.read_csv("emoji_puzzles.csv", encoding="utf-8")

def randomize_puzzles(n):
    #random n rows, it creates list of dictionaries
    return csv.sample(n)[["emojis", "answer"]].to_dict(orient="records")
    