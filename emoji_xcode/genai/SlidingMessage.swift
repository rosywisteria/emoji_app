import SwiftUI
struct SlidingMessageView: View {
    @Binding var show: Bool
    var text: String
    var color: Color = .green

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(color.opacity(0.9))
            .cornerRadius(12)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
            .offset(y: show ? 50 : -200) // offscreen initially, slide down
            .animation(.easeOut(duration: 0.5), value: show)
    }
}

