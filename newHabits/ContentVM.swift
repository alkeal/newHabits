//
//  ContentVM.swift
//  newHabits
//
//  Created by A on 2023-04-19.
//

import Foundation
import Firebase

//**** FUNKTIONALITETEN I APPEN FÖr FIRESTORE SKRIVS HÄR ****


class ContentVM : ObservableObject {
    
    
    // så vi får tag på databasen
    let db = Firestore.firestore()
    
    // Här får vi tag på användarens id så vi får rätt data
    let auth = Auth.auth()
    
    
    // Här skapar jag en lista som visar upp en habits och dess olika egenskaper
    // Och det är en tom array med habit
    @Published var habits = [Habit]()
    
    
    func deleteFromFirestoreAndList(index: Int){
        
        // Detta ger oss användaren och sökvägen till dess dokument
        // guard så om det blir nil så
        guard let user = auth.currentUser else {return}
        // Samlingen heter users , sedan dokument för de specifika användarna och sedan deras "habits"
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        //Här får vi tag på rätt dokument i indexet när vi raderar
        let habit = habits[index]
        
        if let id = habit.id {
            habitsRef.document(id).delete()
        }
        
        
    }
    
    
    func toggle(habit: Habit){
        
        
        // guard så om det blir nil så
        guard let user = auth.currentUser else {return}
        // Samlingen heter users , sedan dokument för de specifika användarna och sedan deras "habits"
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            
            // När knappen trycks ökar din streak med 1 poäng
          let newStreak = habit.isPressed ? habit.streak + 1 : 0

            // Här sätter vi vilken streak som vi ska uppnå alltså summan
           let completedStreak = newStreak == 7 ? true : false
           

            habitsRef.document(id).updateData(["done" : completedStreak, "streak": newStreak, "isPressed": true])

        }
        
        
    }
      // Här sparar vi datan till firestore
    func saveDataToFirestore(nameOfHabit: String){
        
        // guard så om det blir nil så
        guard let user = auth.currentUser else {return}
        // Samlingen heter users , sedan dokument för de specifika användarna och sedan deras "habits"
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = Habit(newHabit: nameOfHabit,streak: 0)
        
        
        // Spara
        do {
            try habitsRef.addDocument(from: habit)
        } catch {
            print("Could not save to db")
            
        }
    }
    
    
    
    
    // Så vi kan läsa från firestore och se ändringar med en snapshotlistner
    
    func updateAppAndListenToFirestore(){
        
        // guard så om det blir nil så
        guard let user = auth.currentUser else {return}
        
        // Samlingen heter users , sedan dokument för de specifika användarna och sedan deras "habits"
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        // När något händer i "habits" då lyssnar snapshot på det och uppdaterar
        habitsRef.addSnapshotListener() {
            snapshot, err in
            // Om snapshotet är nil så gör den inget och går vidare , därför använder vi guard.
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                
                print("Error getting doc \(err)")
                
            } else {
                
                // Nur läser vi ner de nya doc men tömmer de gamla först så det ej blir dubbletter.
                self.habits.removeAll()
                
                for document in snapshot.documents {
                    do {
                        // Omvandla dokumentet till en habit så de kan visas upp i en ny lista
                        // med try så försöker vi hämta dokumentet men om det blir fel så printar vi nedan på catch
                        let habit = try document.data(as : Habit.self)
                        
                        // Om try funkar så lägger vi in våran habit i en lista
                        self.habits.append(habit)
                        
                    } catch {
                        // Här fångar vi om det är fel och printar ut det
                        print("Cant read from db ,Error! ")
                        
                    }
                    
                 }
                
             }
            
         }
        
    }
    
    
}
