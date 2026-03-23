//
//  PoolTableBookingApp.swift
//  PoolTableBooking
//
//  Created by Shilp Patel on 3/22/26.
//

import SwiftUI

@main
struct PoolTableBookingApp: App {
    @State private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authVM)
                .task { authVM.checkExistingCredential() }
        }
    }
}
