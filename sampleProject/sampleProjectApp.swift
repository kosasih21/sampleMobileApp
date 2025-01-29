//
//  sampleProjectApp.swift
//  sampleProject
//
//  Created by vincent kosasih on 1/28/25.
//

import SwiftUI
import Firebase

@main
struct sampleProjectApp: App {
    init() {
        FirebaseApp.configure()
        print("Firebase has been Configured!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
