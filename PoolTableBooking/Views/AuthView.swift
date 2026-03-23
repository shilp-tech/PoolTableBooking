import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @Environment(AuthViewModel.self) var authVM

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Pool table icon
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(hex: "00853E"))
                        .frame(width: 110, height: 110)
                        .shadow(color: Color(hex: "00853E").opacity(0.45), radius: 20, x: 0, y: 10)

                    // Felt surface
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "006B30"))
                        .frame(width: 70, height: 48)

                    // Corner pockets
                    ForEach([-1, 1], id: \.self) { h in
                        ForEach([-1, 1], id: \.self) { v in
                            Circle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: 9, height: 9)
                                .offset(x: CGFloat(h) * 29, y: CGFloat(v) * 17)
                        }
                    }
                    // Side pockets
                    ForEach([-1, 1], id: \.self) { h in
                        Circle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: 9, height: 9)
                            .offset(x: CGFloat(h) * 29, y: 0)
                    }
                    // Cue ball
                    Circle()
                        .fill(Color.white)
                        .frame(width: 11, height: 11)
                        .shadow(color: .black.opacity(0.2), radius: 2)
                }

                Spacer().frame(height: 36)

                Text("UNT Pool Table")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Booking")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "00853E"))

                Spacer().frame(height: 10)

                Text("Reserve your table in seconds.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                VStack(spacing: 14) {
                    SignInWithAppleButton(.signIn) { request in
                        authVM.configureRequest(request)
                    } onCompletion: { result in
                        authVM.handleCompletion(result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 54)
                    .cornerRadius(14)

                    if !authVM.errorMessage.isEmpty {
                        Text(authVM.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    #if targetEnvironment(simulator)
                    Button("Skip — Simulator Test") {
                        authVM.debugSignIn()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    #endif
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 52)
            }
        }
    }
}

#Preview {
    AuthView()
        .environment(AuthViewModel())
}
