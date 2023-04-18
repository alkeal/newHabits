//
//  ContentView.swift
//  newHabits
//
//  Created by A on 2023-04-17.
//

import SwiftUI
import Firebase

struct ContentView: View {
    // så vi får tag på databasen
    let db = Firestore.firestore()
    
    // Här skapar jag en lista som visar upp en habits och dess olika egenskaper
    // Och det är en tom array med habit
    @State var habits = [Habit]()
    
    var body: some View {
        
        
        Text("New Habits")
            .font(.title2)
            .padding()
            .background(Rectangle()
                .foregroundColor(.white)
                        //hörnen blir runda på kortet
                .cornerRadius(15)
                .shadow(radius: 15))
        
        VStack {
            
           // Image(systemName: "checkmark.circle")
            //Här ska vi visa upp våra habits i en lista
            List {
                
                 // Och en specifik rad för de olika habits
                 // Den visar varja habit i en egen rad med dess innehåll
                ForEach(habits) { habit in
                    // Namnet på vanan och en ruta där vi kan checka av varje dag i vecka
                    // In Hstack så brevid varandra
                    HStack{
                        // Namnet på våran habit
                        Text(habit.newHabit)
                        Spacer()
                        
                       // Text(habit.monday)
                            
                        
                        // Vi ska ha en checkbox för de specifika dagarna som kan ändras
                        //checkmark.circle om den är utförd(true) annars en tom cirkel(false).
                           Button(action: {
                               
                               if let id = habit.id {
                                   db.collection("habits").document(id).updateData(["done" : !habit.done])
                                   
                               }
                               
                           }, label: {
                               // Här visar vi upp bilderna
                               // Men om vanan är utförd för den dag så får vi den i checkade bilden
                               // Om den är true alltså utförd visas den andra bilden med den i checkade cirkeln
                             Image(systemName: habit.done ? "checkmark.circle" : "questionmark.circle.fill")
                               
                           })
                        
                    }
                    VStack{
                        
                        HStack{
                            Text("Måndag")
                            Spacer()
                            Image(systemName: habit.monday ? "checkmark.circle" :"1.circle")
                          
                        }
                        HStack{
                            Text("Tisdag")
                            Spacer()
                            Image(systemName: habit.tuesday ? "checkmark.circle" :"2.circle")
                          
                        }
                        HStack{
                            Text("Onsdag")
                            Spacer()
                            Image(systemName: habit.wednesday ? "checkmark.circle" :"3.circle")
                          
                        }
                        
                        HStack{
                            Text("Torsdag")
                            Spacer()
                            Image(systemName: habit.thursday ? "checkmark.circle" :
                                    "4.circle")
                            
                        }
                        HStack{
                            Text("Fredag")
                            Spacer()
                            Image(systemName: habit.friday ? "checkmark.circle" :"5.circle")
                          
                        }
                        HStack{
                            Text("Lördag")
                            Spacer()
                            Image(systemName: habit.saturday ? "checkmark.circle" :"6.circle")
                          
                        }
                        HStack{
                            Text("Söndag")
                            Spacer()
                            Image(systemName: habit.sunday ? "checkmark.circle" :"7.circle")
                          
                        }
                        
                    }
                    
                }
                
            }
            
            
            
           
        } .onAppear(){
            
            // Här lyssnar den efter ändringar och uppdaterar när den märker av dem
           updateAppAndListenToFirestore()
          //  saveDataToFirestore(nameOfHabit: "Träna")
         
        }
        .padding()
    }
    
    
    
    
    
    // Här sparar vi datan till firestore
    func saveDataToFirestore(nameOfHabit: String){
       
        let habit = Habit(newHabit: nameOfHabit)
        // Spara
        do {
         try db.collection("habits").addDocument(from: habit)
        } catch {
            print("Could not save to db")
        }
    }
    
    
    
    
    // Så vi kan läsa från firestore och se ändringar med en snapshotlistner
    
    func updateAppAndListenToFirestore(){
        
        // När något händer i "habits" då lyssnar snapshot på det och uppdaterar
        db.collection("habits").addSnapshotListener() {
            snapshot, err in
            // Om snapshotet är nil så gör den inget och går vidare , därför använder vi guard.
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting doc \(err)")
            } else{
                // Nur läser vi ner de nya doc men tömmer de gamla först så det ej blir dubbletter.
                habits.removeAll()
                for document in snapshot.documents {
                    do {
                    // Omvandla dokumentet till en habit så de kan visas upp i en ny lista
                        // med try så försöker vi hämta dokumentet men om det blir fel så printar vi nedan på catch
                   let habit = try document.data(as : Habit.self)
                        // Om try funkar så lägger vi in våran habit i en lista
                        habits.append(habit)
                    } catch {
                        // Här fångar vi om det är fel och printar ut det
                        print("Cant read from db ,Error! ")
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
