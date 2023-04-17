//
//  ContentView.swift
//  newHabits
//
//  Created by A on 2023-04-17.
//

import SwiftUI
import Firebase

struct ContentView: View {
    // så vi får tag på databsen
    let db = Firestore.firestore()
    
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        } .onAppear(){
            
            db.collection("test").addDocument(data: ["name": "Tomaten"])
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
