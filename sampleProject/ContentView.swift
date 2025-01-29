//
//  ContentView.swift
//  sampleProject
//
//  Created by vincent kosasih on 1/28/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @State private var name: String = ""  // User input field
    @State private var visitors: [String] = [] // Stores visitor names
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            // Original Hello World
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.title)
                .padding()

            // Form for entering name
            Form {
                Section(header: Text("Enter Your Name")) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: addVisitor) {
                        Text("Check In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(name.isEmpty) // Disable button if no name
                }
            }
            .padding()

            // Display list of visitors
            List {
                Section(header: Text("Visitors")) {
                    ForEach(visitors, id: \.self) { visitor in
                        Text(visitor)
                    }
                }
            }
        }
        .onAppear(perform: trackPageVisit) // Logs visit when page appears
    }
    
    /// Logs a visitor's page view in Firestore
    private func trackPageVisit() {
        let visitData = [
            "timestamp": Timestamp()
        ] as [String : Any]

        db.collection("page_visits").addDocument(data: visitData) { error in
            if let error = error {
                print("Error tracking visit: \(error)")
            } else {
                print("Page visit logged!")
            }
        }
        
        fetchVisitors() // Refresh visitor list
    }
    
    /// Adds the visitor’s name to Firestore
    private func addVisitor() {
        let newVisitor = [
            "name": name,
            "timestamp": Timestamp()
        ] as [String : Any]

        db.collection("visitors").addDocument(data: newVisitor) { error in
            if let error = error {
                print("Error adding visitor: \(error)")
            } else {
                print("\(name) checked in!")
                name = "" // Clear input after submission
                fetchVisitors() // Refresh visitor list
            }
        }
    }

    /// Fetches the list of visitors from Firestore
    private func fetchVisitors() {
        db.collection("visitors")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching visitors: \(error)")
                } else {
                    visitors = snapshot?.documents.compactMap { doc in
                        doc["name"] as? String
                    } ?? []
                }
            }
    }
}

#Preview {
    ContentView()
}
