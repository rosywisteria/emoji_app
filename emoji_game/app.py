

from flask import Flask, jsonify, request
from flask_cors import CORS

from model import compute_similarity
import pandas as pd
import os

app = Flask(__name__)
CORS(app)

csv = pd.read_csv("emoji_puzzles.csv", encoding="utf-8")
def randomize_puzzles(n):
    #random n rows, it creates list of dictionaries
    return csv.sample(n)[["emojis", "answer"]].to_dict(orient="records")

@app.route("/get_puzzles", methods=["GET"])
def get_puzzles():
    random_puzzles = randomize_puzzles(3)  # pick 3 random puzzles
    puzzles = [{"emojis": p["emojis"], "answer": p["answer"]} for p in random_puzzles]
    return jsonify(puzzles)

@app.route("/check_guess", methods=["POST"])
def check_guess():
    data = request.json #data needed: guess and correct answer
    guess = data.get("guess", "")
    answer = data.get("answer", "")
    emojis = data.get("emojis", "")
    if not guess or not answer or not emojis:
        return jsonify({"error": "Missing guess or answer"}), 400

    # guess_embedding = model.encode([guess])[0]
    # answer_embedding = model.encode([answer])[0]

    if guess.strip().lower() == answer.strip().lower():
        similarity = 1.0
        similarityString = "Perfect✅"
    else:
        similarity = round(float(compute_similarity(emojis, guess)), 3)
        print(similarity)

        if similarity >=0.9:
            similarityString = "Scalding🌋"
        elif similarity >=0.7:
            similarityString = "Pretty Hot🔥"
        elif similarity >=0.4:
            similarityString= "A Bit Chilly🧊🧥"
        else:
            similarityString = "Siberia🥶"


    return jsonify({
        "guess":guess,
        "answer":answer,

        "similarity":similarity, # state similarity score 0-1
        "similarityString":similarityString #proximity in terms of words
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)