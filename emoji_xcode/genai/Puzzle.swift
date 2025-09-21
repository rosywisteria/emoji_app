import Foundation

struct Puzzle: Identifiable, Codable {
    var id = UUID()
    let emojis: String
    let answer: String
    
    //no backend involvement
    var userInput: String = ""
    var isSolved: Bool = false
    ////////////////////////////////////////////////
    
    var similarityString: String = ""
    var similarity: Double? = nil
    
    private enum CodingKeys: String, CodingKey { //decodes emojis and answer from JSON
        case emojis, answer
    }
}
