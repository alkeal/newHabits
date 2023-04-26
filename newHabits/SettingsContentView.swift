//
//  SettingsContentView.swift
//  newHabits
//
//  Created by A on 2023-04-26.
//

import SwiftUI

struct SettingsContentView: View {
    
    @State var goBackToView = false
    
    
    var body: some View {
        
       NavigationView {
   // Logga ut knapp så skickar oss tillbaka till startsidan i appen
   
   Button(action: {
       
    
            goBackToView = true
               

   }, label: {
       
       Image(systemName: "person.crop.circle.badge.xmark")
           .foregroundColor(.orange)
           .font(.system(size: 25.0))
           .padding(10)
   })
     
   }
       .sheet(isPresented: $goBackToView, content: {
           ContentView()
       })
    }
}

struct SettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContentView()
    }
}
