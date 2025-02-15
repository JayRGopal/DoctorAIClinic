//
//  AuthManager.swift
//  DoctorAIClinic
//
//  Created by Jay Gopal on 2/15/25.
//

import Foundation

enum UserRole: String, Codable {
    case patient
    case provider
}

struct User: Codable {
    let email: String
    let password: String
    let role: UserRole
    let doctorEmail: String?
}

class AuthManager {
    static let shared = AuthManager()
    
    private var users: [String: User] = [:]  // key: email (lowercased)
    private let fileName = "users.json"
    
    private init() {
        loadUsers()
    }
    
    private var fileURL: URL? {
        let fm = FileManager.default
        guard let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsURL.appendingPathComponent(fileName)
    }
    
    private func loadUsers() {
        guard let url = fileURL,
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: User].self, from: data) else {
            return
        }
        users = decoded
    }
    
    private func saveUsers() {
        guard let url = fileURL,
              let data = try? JSONEncoder().encode(users) else {
            return
        }
        try? data.write(to: url)
    }
    
    func registerUser(email: String, password: String, role: UserRole, doctorEmail: String?) -> Bool {
        let lowerEmail = email.lowercased()
        if users[lowerEmail] != nil {
            return false // User already exists.
        }
        let newUser = User(email: lowerEmail, password: password, role: role, doctorEmail: doctorEmail)
        users[lowerEmail] = newUser
        saveUsers()
        return true
    }
    
    func loginUser(email: String, password: String) -> Bool {
        let lowerEmail = email.lowercased()
        guard let user = users[lowerEmail] else {
            return false
        }
        return user.password == password
    }
    
    func getUser(email: String) -> User? {
        return users[email.lowercased()]
    }
}
