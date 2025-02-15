//
//  SignUpView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct SignUpView: View {
    var userRole: UserRole
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var doctorEmail: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up as \(userRole == .patient ? "Patient" : "Medical Professional")")
                .font(.title)
                .padding(.top, 40)

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.themeGray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 20)

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .padding()
                .background(Color.themeGray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 20)

            SecureField("Confirm Password", text: $confirmPassword)
                .textContentType(.newPassword)
                .padding()
                .background(Color.themeGray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 20)

            if userRole == .patient {
                TextField("Doctor's Email (optional)", text: $doctorEmail)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.themeGray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
            }

            Button(action: {
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match."
                    return
                }
                if AuthManager.shared.registerUser(email: email, password: password, role: userRole, doctorEmail: userRole == .patient ? doctorEmail : nil) {
                    isLoggedIn = true
                } else {
                    errorMessage = "User already exists."
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            NavigationLink(destination: SignInView(userRole: userRole)) {
                Text("Already have an account? Sign In")
                    .foregroundColor(Color.primaryBlue)
            }
            .padding(.top, 10)

            Spacer()
        }
        .background(
            NavigationLink(destination: userRole == .patient ? AnyView(PatientMainTabView()) : AnyView(ProviderMainTabView()),
                           isActive: $isLoggedIn) { EmptyView() }
            .hidden()
        )
        .navigationBarTitle("Sign Up", displayMode: .inline)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView(userRole: .patient)
        }
    }
}
