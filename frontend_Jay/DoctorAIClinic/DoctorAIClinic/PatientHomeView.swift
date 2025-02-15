import SwiftUI
import SwiftUIPager
import MessageUI

// MARK: - CarouselItem Model
struct CarouselItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let isReferral: Bool
}

struct PatientHomeView: View {
    @State private var showingMessageCompose = false
    @State private var messageBody = ""
    @StateObject var page: Page = .first()
    
    // Define carousel items with meaningful content.
    let carouselItems: [CarouselItem] = [
        CarouselItem(
            imageName: "virtualVisit",
            title: "Virtual Visits",
            description: "Connect with top physicians from the comfort of your home.",
            isReferral: false
        ),
        CarouselItem(
            imageName: "referralOffer",
            title: "Make",
            description: "$100", // "$100" will be styled larger.
            isReferral: true
        ),
        CarouselItem(
            imageName: "patientStories",
            title: "Patient Success Stories",
            description: "Read inspiring testimonials from our patients.",
            isReferral: false
        )
    ]
    
    // Auto-scroll timer: carousel moves every 10 seconds.
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    // Calculate card width so that adjacent items peek in.
    var cardWidth: CGFloat {
        UIScreen.main.bounds.width * 0.8
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Carousel container with primary blue background.
                ZStack {
                    Color.primaryBlue
                    Pager(page: page, data: carouselItems, id: \.id) { item in
                        ZStack {
                            // Background image from assets.
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: cardWidth, height: 250)
                                .clipped()
                                .cornerRadius(15)
                            
                            // Overlay content.
                            if item.isReferral {
                                // Referral overlay with "Make $100" and call-to-action.
                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                                Text(item.title)
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                Text(item.description)
                                                    .font(.system(size: 36, weight: .bold))
                                                    .foregroundColor(.yellow)
                                            }
                                            Text("Refer a friend and earn rewards.")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            Button(action: {
                                                // Pre-compose the referral SMS text.
                                                messageBody = "Discover Kyron Medical's Virtual Clinic! Enjoy an exclusive $50 discount on your first visit. Download now: https://apps.apple.com/app/kyronmedical?ref=uniqueCode"
                                                showingMessageCompose = true
                                            }) {
                                                Text("Earn Rewards Now")
                                                    .font(.headline)
                                                    .padding()
                                                    .background(Color.blue.opacity(0.8))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        Spacer()
                                        // SF Symbol icon for referral.
                                        Image(systemName: "gift.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                }
                            } else {
                                // Standard overlay for non-referral items.
                                VStack {
                                    Spacer()
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text(item.description)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .itemSpacing(10)            // Allows adjacent items to peek in.
                    .loopPages(true)
                    .interactive(scale: 0.8)
                    .frame(height: 300)
                    .onReceive(timer) { _ in
                        withAnimation {
                            page.update(.next)
                        }
                    }
                }
                .frame(height: 300)
                
                // Dot indicator for current carousel page.
                HStack(spacing: 8) {
                    ForEach(0..<carouselItems.count, id: \.self) { index in
                        Circle()
                            .fill(index == page.index ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                // Large button to start virtual visit.
                NavigationLink(destination: ContentView()) {
                    HStack {
                        Image(systemName: "video.fill")
                            .font(.title)
                        Text("Start Virtual Visit")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                
                // Additional home screen text.
                Text("Welcome to Kyron Medical Virtual Clinic")
                    .font(.headline)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            // Present the SMS composer when needed.
            .sheet(isPresented: $showingMessageCompose) {
                MessageComposeView(bodyText: messageBody)
            }
        }
    }
}

struct PatientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PatientHomeView()
    }
}
