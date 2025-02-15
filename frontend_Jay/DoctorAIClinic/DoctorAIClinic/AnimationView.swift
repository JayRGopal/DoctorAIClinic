import SwiftUI

struct AnimationView: View {
    @Binding var isAnimating: Bool
    @State private var scale: CGFloat = 1.0

    var body: some View {
        
        
        VStack(spacing: 40) {
            // Company Logo at the top.
            Image("Kyron Medical Icon in Text Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()
            
            Circle()
                .fill(Color.primaryBlue)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .opacity(isAnimating ? 1.0 : 0.5)
                .onAppear {
                    if isAnimating {
                        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            scale = 1.2
                        }
                    }
                }
                .onChange(of: isAnimating) { animating in
                    if animating {
                        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            scale = 1.2
                        }
                    } else {
                        withAnimation {
                            scale = 1.0
                        }
                    }
                }
        }
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView(isAnimating: .constant(true))
    }
}
