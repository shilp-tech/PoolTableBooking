import Foundation
import AuthenticationServices
import CryptoKit
import Observation

@Observable
class AuthViewModel {
    var isAuthenticated: Bool = false
    var userName: String = ""
    var userEmail: String = ""
    var errorMessage: String = ""

    private let userIDKey    = "apple_userID"
    private let userNameKey  = "apple_userName"
    private let userEmailKey = "apple_userEmail"

    private var currentNonce: String = ""

    // MARK: - App Launch

    func checkExistingCredential() {
        guard let userID = UserDefaults.standard.string(forKey: userIDKey) else { return }
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { [weak self] state, _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                switch state {
                case .authorized:
                    self.userName = UserDefaults.standard.string(forKey: self.userNameKey) ?? ""
                    self.userEmail = UserDefaults.standard.string(forKey: self.userEmailKey) ?? ""
                    self.isAuthenticated = true
                case .revoked, .notFound, .transferred:
                    self.signOut()
                @unknown default:
                    break
                }
            }
        }
    }

    // MARK: - SignInWithAppleButton Handlers

    func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    func handleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            processCredential(authorization)
        case .failure(let error):
            guard let authError = error as? ASAuthorizationError,
                  authError.code != .canceled else { return }
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Simulator Bypass (development only)

    #if targetEnvironment(simulator)
    func debugSignIn() {
        userName = "Test User"
        userEmail = "test@simulator.com"
        isAuthenticated = true
    }
    #endif

    // MARK: - Sign Out

    func signOut() {
        UserDefaults.standard.removeObject(forKey: userIDKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        isAuthenticated = false
        userName = ""
        userEmail = ""
        errorMessage = ""
    }

    // MARK: - Internal

    private func processCredential(_ authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        let userID = credential.user

        let name: String
        if let fullName = credential.fullName,
           let given = fullName.givenName, !given.isEmpty {
            name = [given, fullName.familyName].compactMap { $0 }.joined(separator: " ")
        } else {
            name = UserDefaults.standard.string(forKey: userNameKey) ?? ""
        }
        let email = credential.email ?? UserDefaults.standard.string(forKey: userEmailKey) ?? ""

        UserDefaults.standard.set(userID, forKey: userIDKey)
        UserDefaults.standard.set(name,   forKey: userNameKey)
        UserDefaults.standard.set(email,  forKey: userEmailKey)

        userName = name
        userEmail = email
        errorMessage = ""
        isAuthenticated = true
    }

    // MARK: - Nonce Helpers

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        precondition(status == errSecSuccess, "Failed to generate nonce")
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(bytes.map { charset[Int($0) % charset.count] })
    }

    private func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}
