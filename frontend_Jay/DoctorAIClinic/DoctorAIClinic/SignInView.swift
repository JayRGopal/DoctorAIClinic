//
//  SignInView.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import SwiftUI

struct SignInView: View {
    var userRole: UserRole
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In as \(userRole == .patient ? "Patient" : "Medical Professional")")
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
                .textContentType(.password)
                .padding()
                .background(Color.themeGray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 20)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
            }

            Button(action: {
                if AuthManager.shared.loginUser(email: email, password: password) {
                    isLoggedIn = true
                } else {
                    errorMessage = "Invalid credentials."
                }
            }) {
                Text("Sign In")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            NavigationLink(destination: SignUpView(userRole: userRole)) {
                Text("Don't have an account? Sign Up")
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
        .navigationBarTitle("Sign In", displayMode: .inline)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView(userRole: .patient)
        }
    }
}
