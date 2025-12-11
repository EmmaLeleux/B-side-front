//
//  UserViewModel.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import Foundation
import Observation
import KeychainAccess

@Observable
class LoginViewModel {
    
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "com.b-side.app")
    
    var token: String? {
        didSet {
                    if let token = token {
                        try? keychain.set(token, key: "authToken")
                    } else {
                        try? keychain.remove("authToken")
                    }
                }
    }
    
    var currentUser: User? {
            didSet {
                if let encoded = try? JSONEncoder().encode(currentUser) {
                    try? keychain.set(encoded, key: "currentUser")
                } else {
                    try? keychain.remove("currentUser")
                }
            }
        }
    
    var errorMessage: String? = nil
    var isAuthenticated: Bool {
            return token != nil && currentUser != nil
        }
    
    
    init() {
           
            token = try? keychain.get("authToken") ?? nil
            
            if let data = try? keychain.getData("currentUser"),
               let user = try? JSONDecoder().decode(User.self, from: data) {
                currentUser = user
            }
        }
    
    
    func login(username: String, password: String) async {
        

        guard let url = URL(string: "http://localhost:8080/user/login") else {
            print("Mauvais URL")
            return
        }
        
        
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //pas besoin d'authentification dans cette route

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Erreur encodage body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                
//                let jsonString = String(data: data, encoding: .utf8)
//                print(jsonString ?? "No JSON")

                do {
                    let decoder = JSONDecoder()
                    
                    let decoded = try decoder.decode(LoginResponse.self, from: data)
                    

                    DispatchQueue.main.async {
                        self.token = decoded.token
                        self.currentUser = decoded.user
                        self.errorMessage = nil
                        
                        //sauvegarde le token
                        UserDefaults.standard.set(decoded.token, forKey: "authToken")
                        NotificationCenter.default.post(name: .didLogin, object: nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "identifiant ou mot de passe incorrect"
                    }
                }
            } else if let error {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur réseau: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func logout() {
            token = nil
            currentUser = nil
        }
    
    func createUser(username: String, password: String, picture: String) async throws {
        guard let url = URL(string: "http://localhost:8080/user") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = Registration(
            username: username,
            password: password,
            picture: picture
        )

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8) ?? "No data")

        await login(username: username, password: password)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        
    }
    
    func updateCurrentUser(with fields: [String: Any]) async throws {
        
        guard let token = token else { throw URLError(.userAuthenticationRequired) }
        guard let url = URL(string: "http://localhost:8080/user/") else { throw URLError(.badURL) }


        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: fields)

        let (data, response) = try await URLSession.shared.data(for: request)
//        let jsonString = String(data: data, encoding: .utf8)
//        print(jsonString ?? "No JSON")


        let decoder = JSONDecoder()
        let updatedUser = try decoder.decode(User.self, from: data)
//        print(updatedUser)

        await MainActor.run {
            self.currentUser = updatedUser
        }

    }

}


extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
}
