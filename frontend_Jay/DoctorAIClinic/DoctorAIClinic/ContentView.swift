import SwiftUI

struct ContentView: View {
    // The full conversation transcript that is maintained behind the scenes.
    @State private var transcript: String = "Doctor said: What brings you in today?"
    
    // The core prompt to instruct the AI doctor.
    private let corePrompt: String = """
    You are a physician seeing a patient. Your goal is to be empathetic and figure out the differential diagnosis, as well as the assessment and plan. You may continue the conversation or start wrapping things up, as you see fit. You need to collect enough information to understand the situation and make the patient feel heard.
    """
    
    // Our speech manager handles both speech recognition and text-to-speech.
    @StateObject private var speechManager = SpeechManager()
    
    // A flag to track whether we are currently recording.
    @State private var isRecording = true
    
    @State private var speechEndTimer: Timer?
    
    // State var to show/hide animation
    @State private var isSpeaking = false
    
    
    var body: some View {
        ZStack {
            // Background using our theme.
            Color.themeWhite.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Company Logo at the top.
                Image("Kyron Medical Icon in Text Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                
                // A microphone button in the center.
                Button(action: {
                    toggleRecording()
                }) {
                    Image(systemName: isRecording ? "mic.fill" : "mic.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.primaryBlue)
                        .padding()
                        .background(Circle().fill(Color.themeGray.opacity(0.2)))
                }
                
                if isSpeaking {
                    AnimationView(isAnimating: $isSpeaking)
                        .transition(.opacity)
                }
                
                // (Optional) A label showing the current recognized speech.
                Text(speechManager.transcribedText)
                    .foregroundColor(.themeGray)
                    .padding()
            }
        }
        .navigationBarTitle("Doctor AI Clinic", displayMode: .inline)
        .navigationBarColor(UIColor(Color.primaryBlue))
        .onChange(of: speechManager.transcribedText) { newText in
            // 1. Cancel any previous timer
            speechEndTimer?.invalidate()

            // 2. If empty, nothing to send yet
            guard !newText.isEmpty else { return }

            // 3. Start a 2-second timer
            speechEndTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                print("No new speech for 2 seconds—sending to backend...")
                transcript.append("\nPatient said: \(newText)")
                sendToBackend()

                // Clear the recognized text so we don't keep re-appending it
                speechManager.transcribedText = ""
                speechManager.stopRecording()
                speechManager.startRecording()
            }
        }
    }
    
    /// Toggles the speech recognition on and off.
    private func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            // Clear any previous transcription (if desired) and start recording.
            speechManager.transcribedText = ""
            speechManager.startRecording()
        } else {
            // Stop recording.
            speechManager.stopRecording()
        }
    }
    
    /// Sends the current transcript (with the core prompt) to the backend.
    private func sendToBackend() {
        guard let url = URL(string: "http://127.0.0.1:5000/chat") else {
            print("Invalid backend URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let payload: [String: Any] = [
            "core_prompt": corePrompt,
            "transcript": transcript
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("Error serializing JSON payload: \(error)")
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Debug: Log the outgoing transcript.
        print("Sending transcript to backend:")
        print(transcript)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Networking error: \(error)")
                return
            }
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Invalid response from backend")
                return
            }
            
            // Debug: Print the backend response.
            print("Backend response:")
            print(jsonResponse)
            
            // On receiving a response, extract the doctor's reply and transcript update.
            DispatchQueue.main.async {
                if let doctorReply = jsonResponse["response"] as? String,
                   let transcriptUpdate = jsonResponse["transcript_update"] as? String {
                    // Append the doctor's reply to the transcript.
                    transcript.append("\n\(transcriptUpdate)")
                    
                    // Speak the doctor's reply.
                    speechManager.speak(text: doctorReply)
                    
                    // Optionally, clear the recognized text after processing.
                    speechManager.transcribedText = ""
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Simple Message struct (no longer directly used for UI, but kept for reference).
struct Message: Identifiable {
    enum Role {
        case doctor, patient
    }
    
    let id = UUID()
    let role: Role
    let text: String
}
