import SwiftUI

struct ContentView: View {
    @StateObject private var bookingManager = BookingManager()
    @Environment(AuthViewModel.self) var authVM

    var body: some View {
        @Bindable var vm = authVM
        if vm.isAuthenticated {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Tables", systemImage: "rectangle.grid.2x2.fill")
                    }

                MyBookingsView()
                    .tabItem {
                        Label("My Bookings", systemImage: "calendar.badge.clock")
                    }
            }
            .environmentObject(bookingManager)
            .tint(Color(hex: "00853E"))
        } else {
            AuthView()
                .animation(.easeInOut, value: vm.isAuthenticated)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
        .environment(AuthViewModel())
}
