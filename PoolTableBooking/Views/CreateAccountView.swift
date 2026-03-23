// CreateAccountView is no longer used — authentication is handled via Sign in with Apple in AuthView.
import SwiftUI

struct CreateAccountView: View {
    var onShowSignIn: () -> Void
    var body: some View { EmptyView() }
}
