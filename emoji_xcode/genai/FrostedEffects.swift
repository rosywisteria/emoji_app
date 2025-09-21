import SwiftUI

struct FrostedButton: View {
    var text: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
//                .frame(width: 200, height: 60)
                .background(
                    Color.purple.opacity(0.6)
                        .blur(radius: 5)
                        .overlay(Color.white.opacity(0.2))
                        .cornerRadius(20)
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
//                .fixedSize()
        }
    }
}

//struct NeumorphicButton: View {
//    var text: String
//    var action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text(text)
//                .font(.title2)
//                .foregroundColor(.white)
//        }
//        .buttonStyle(NeumorphicButtonStyle(bgColor: Color.purple.opacity(0.3))) // Apply neumorphic style
//        .frame(width: 120, height: 60)
//    }
//}
//
//// Existing NeumorphicButtonStyle (unchanged)
//struct NeumorphicButtonStyle: ButtonStyle {
//    var bgColor: Color
//    
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding(5) // Reduced padding to fit 50x25 frame
//            .background(
//                ZStack {
//                    RoundedRectangle(cornerRadius: 8, style: .continuous)
//                        .shadow(color: .white.opacity(0.7), radius: configuration.isPressed ? 3 : 8, x: configuration.isPressed ? -3 : -5,
//                                y: configuration.isPressed ? -3 : -5)
//                        .shadow(color: .black.opacity(0.2), radius: configuration.isPressed ? 3 : 8, x: configuration.isPressed ? 3 : 5,
//                                y: configuration.isPressed ? 3 : 5)
//                        .blendMode(.overlay)
//                    RoundedRectangle(cornerRadius: 8, style: .continuous)
//                        .fill(bgColor)
//                }
//            )
//            .scaleEffect(configuration.isPressed ? 0.9 : 1)
//            .foregroundColor(.black) // Adjusted for contrast, can change back to .white
//            .animation(.spring(response: 0.03, dampingFraction: 0.3), value: configuration.isPressed)
//    }
//}
