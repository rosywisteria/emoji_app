import SwiftUI
import Neumorphic

struct EmojiGuessGameView: View {
    @StateObject var viewModel = PuzzleViewModel()
    //3 puzzles(emoji sequences)
    
    //    Sliding message
    @State private var showMessage = false
    @State private var messageText = ""
    
    //timer setup
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timerAmount = 180 // 180 sec ~ 3 minutes
    @State private var timerOn = false
    

    
    // Game state
    enum GameState {
        case notStarted
        case playing
        case gameOver
    }
    @State private var gameState: GameState = .notStarted
        
        // Computed button text
        var buttonText: String {
            switch gameState {
            case .notStarted: return "Start"
            case .playing: return "Give up"
            case .gameOver: return "Play Again"
            }
        }
    //
    //
    //
    var body: some View {
        ZStack{//background
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
                .blur(radius: 10)
                .opacity(0.8)
            
            // White overlay for glass effect
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .ignoresSafeArea()
                .blur(radius: 10)
                .offset(x: 0, y: 0)
            
            
            ScrollView{
                //beginning of actual app
                VStack(spacing: 30) {
                    //Title of app
                    Text("🎉🤯🧩")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    //start button turns to Give up after click
                    
                    HStack{
                        //timer area
                        Text("\(formatTime(timerAmount))")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(10) // space between text and box
                            .background(Color.white) // white box
                            .cornerRadius(8) // rounded corners
                            .shadow(radius: 2) // optional: slight shadow for depth
                        
                        // Start / Give up / Play Again button
                        Button(action: {
                            switch gameState {
                            case .notStarted:
                                timerOn = true
                                gameState = .playing
                            case .playing:
                                timerOn = false
                                gameState = .gameOver
                                if !viewModel.playerWin {
                                    showWinLoseMessage("You Lost 😢")
                                }
                            case .gameOver:
                                Task {
                                    await viewModel.resetGame()
                                    timerAmount = 180
                                    timerOn = true
                                    gameState = .playing
                                }
                            }
                        }) {
                            Text(buttonText)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 200, height: 60)
                        .background(.ultraThinMaterial) // Frosted blur
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                        
                    }
                    // timer visual
                    GeometryReader { geo in
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(height: 20)
                            .overlay(
                                // Foreground fill bar (moving)
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: max(0, geo.size.width * CGFloat(timerAmount) / 180), height: 20)
                                    .animation(.linear, value: timerAmount)
                                , alignment: .leading
                            )
                    }
                    .frame(height: 20) // geometryreader height

                    
                    //Emoji Horizontal stacks
                    //                1st Row: Emojis 2nd: InputField and Submit 3rd: Proximity Similarity
                    ForEach(viewModel.puzzles.indices, id: \.self) { index in
                        PuzzleRowView(
                            puzzle: $viewModel.puzzles[index],
                            timerOn: timerOn,
                            gameState: gameState,
                            submitAction: {
                                Task {await viewModel.submitGuess(for: index)}
                            }
                        )//puzzlerowview parenth
                    }//for each bracket
                    Spacer()
                }//entire encapsulating vstack
                .padding()
                
                .task { await viewModel.loadPuzzles() } // fetch 3 random puzzles when view appears
            }//scroll view
                if showMessage {
                    SlidingMessageView(
                        show: $showMessage,
                        text: messageText,
                        color: viewModel.playerWin ? .green : .red
                    )
                    .zIndex(1)
                }//show message bracket
            }//z stack bracket?
            
            .onReceive(viewModel.$playerWin) { won in
                if won {
                    timerOn=false
                    gameState = .gameOver
                    showWinLoseMessage("You Won! 🎉")
                }
            }
            .onReceive(timer) { _ in
                    guard timerOn else { return }
                    if timerAmount > 0 {
                        timerAmount -= 1
                    } else {
                        timerOn = false
                        gameState = .gameOver
                        if !viewModel.playerWin {
                            showWinLoseMessage("You Lost 😢")
                        }
                            }//else
                    }   //onreceive
        }//zstack
    func showWinLoseMessage(_ text: String, duration: Double = 3.0) {
        messageText = text
        withAnimation { showMessage = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation { showMessage = false }
        }
    
    }// whole View
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%01d:%02d", minutes, seconds)
        }

    
    }

#Preview {
    EmojiGuessGameView()
}
