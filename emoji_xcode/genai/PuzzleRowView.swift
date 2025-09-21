import SwiftUI
import Neumorphic

struct PuzzleRowView: View {
    @Binding var puzzle: Puzzle
    var timerOn: Bool
    var gameState: EmojiGuessGameView.GameState
    var submitAction: () -> Void

    
    var body: some View {
        //Vstack of three hstacks for each index
        VStack(spacing:10){
            HStack{
                //emoji display area
                Text(puzzle.emojis)
                    .font(.system(size: 30))
            }//1st hstack
            HStack(spacing:10){ //user input field and guess button
                TextField("Enter your guess...", text: Binding(
                    get: { puzzle.userInput }, // read the current value
                    set: { puzzle.userInput = $0 } // update when user types
                        ),
                  prompt: Text("Enter your guess...")
                      .foregroundColor(.gray) // darker gray
                ) //real time updating input field

                .font(.title2)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.purple.opacity(0.2)) // slightly purple background
                .cornerRadius(8)
                .foregroundColor(.black) // makes typed text black
                .frame(maxHeight: .infinity)
                
                Button(action: {
                    Task { submitAction() }
                }) {
                    Text("Guess")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 100, height: 50)
                .background(Color(red: 0.635, green: 0.58, blue: 0.831))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                
                
            }//2nd hstack
            //guess button modifications
            .padding()
            .frame(height: 70)
            .background(Color.white.opacity(0.6))
            .cornerRadius(10)
            .disabled(puzzle.isSolved || !timerOn) //disable after correct/need to have timer running
            ///
            ///
            VStack{//Proximity then similarity
                //proximity score
                HStack{
                    Text("Proximity: \(puzzle.similarity ?? 0, format: .percent.precision(.fractionLength(1)))")
                        .foregroundColor(
                            puzzle.similarity == nil ? .black :
                                (puzzle.similarity! > 0.7 ? .green.opacity(0.6) : .red.opacity(0.6))
                        )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack{
                    //Similarity string
                    Text("Similarity: \(puzzle.similarityString)")
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack{//answer
                    if gameState == .gameOver {
                        Text("Answer: \(puzzle.answer)")
                            .foregroundColor(.black)
                                }
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                
            }//vstack of prox and sim
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10)
            .background(Color.white.opacity(0.6))
            
            
        }//vstack for each puzzle
        .opacity(puzzle.isSolved ? 0.5 : 1.0) // indicate solved
            
    }//view bracket
}
