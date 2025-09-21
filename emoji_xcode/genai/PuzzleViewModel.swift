import SwiftUI
@MainActor
class PuzzleViewModel: ObservableObject {
    @Published var puzzles: [Puzzle] = []
    @Published var playerWin: Bool = false
    
    func updatePlayerWin() {
        playerWin = puzzles.allSatisfy { $0.isSolved }
    }
    
    let backendURL = "http://10.48.124.96:5000"
    
    func loadPuzzles() async{ //fetches JSON and decodes into Puzzle model
        guard let url = URL(string: "\(backendURL)/get_puzzles") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //test
            if let backend_response = String(data: data, encoding: .utf8) {
                print("Backend response:", backend_response)
            }
            //test
            let decoder = JSONDecoder()
            let fetchedPuzzles = try decoder.decode([Puzzle].self, from: data)
            await MainActor.run {
                self.puzzles = fetchedPuzzles
            }
        } catch {
            print("Error fetching puzzles: \(error)")
        }
    }
    
    func submitGuess(for index: Int) async {
        guard puzzles.indices.contains(index) else { return }
        guard let url = URL(string: "\(backendURL)/check_guess") else { return }
        
        let trimmedGuess=puzzles[index].userInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedGuess.isEmpty else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "guess": puzzles[index].userInput,
            "answer": puzzles[index].answer,
            "emojis": puzzles[index].emojis]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            struct CheckGuessResponse: Codable {
                let guess: String
                let answer: String
                let similarity: Double
                let similarityString: String
            }
            let response = try JSONDecoder().decode(CheckGuessResponse.self, from: data)
                
            // Update puzzle

            var updatedPuzzle = puzzles[index]
            updatedPuzzle.similarity = response.similarity
            updatedPuzzle.similarityString = response.similarityString
            
            if response.similarity==1.0{updatedPuzzle.isSolved=true}
            
            puzzles[index] = updatedPuzzle
            puzzles[index].userInput = ""
            
            updatePlayerWin()//check if all puzzles are solved
            } catch {
                print("Error submitting guess:", error)
            }
    }
    
    func resetGame() async{
        for i in puzzles.indices {
            puzzles[i].userInput = ""
            puzzles[i].isSolved = false
        }
        playerWin = false
        await loadPuzzles() // reload puzzles from backend
    }
    
}
