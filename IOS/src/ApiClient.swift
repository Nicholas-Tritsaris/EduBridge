// iOS/src/ApiClient.swift
import Foundation

class ApiClient {
    static let shared = ApiClient()
    
    private let baseURL = "http://192.168.1.100:5000" // Change to your server IP
    private let session = URLSession.shared
    
    enum ApiError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(String)
    }
    
    // MARK: - Auth Endpoints
    
    func signup(email: String, password: String, completion: @escaping (Result<AuthResponse, ApiError>) -> Void) {
        let endpoint = baseURL + "/api/auth/signup"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: String] = ["email": email, "password": password]
        
        postRequest(url: url, body: body, completion: completion)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, ApiError>) -> Void) {
        let endpoint = baseURL + "/api/auth/login"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: String] = ["email": email, "password": password]
        
        postRequest(url: url, body: body, completion: completion)
    }
    
    func verifyEmail(email: String, code: String, completion: @escaping (Result<AuthResponse, ApiError>) -> Void) {
        let endpoint = baseURL + "/api/auth/verify-email"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: String] = ["email": email, "code": code]
        
        postRequest(url: url, body: body, completion: completion)
    }
    
    func resendVerification(email: String, completion: @escaping (Result<APIBaseResponse, ApiError>) -> Void) {
        let endpoint = baseURL + "/api/auth/resend-verification"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: String] = ["email": email]
        
        postRequest(url: url, body: body, completion: completion)
    }
    
    // MARK: - Helper Methods
    
    private func postRequest<T: Decodable>(url: URL, body: [String: String], completion: @escaping (Result<T, ApiError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.networkError("Failed to serialize request")))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

// MARK: - Response Models

struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let token: String?
    let user: UserData?
}

struct APIBaseResponse: Codable {
    let success: Bool
    let message: String
}

struct UserData: Codable {
    let email: String
    let verified: Bool
}
