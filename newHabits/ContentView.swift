//
//  ContentView.swift
//  newHabits
//
//  Created by A on 2023-04-17.
//

import SwiftUI
import Firebase

// Här väljer vilken view som ska visas först , eller tillexempel under specifika krav
struct ContentView : View {
    
    @State var signedIn = false

    var body: some View {
        
        if !signedIn {
            // dollartecken om man ska skicka med hela statet
            StartPageView(signedIn: $signedIn)
                
        } else{
            HabitsView()
        }
            
        
    }
    
}


struct StartPageView : View {
    
    // då vi måste skicka med hela
   @Binding var signedIn : Bool
    
    var auth = Auth.auth()
    
    
    var body: some View {
        
        ZStack{
            
            Color(.systemGray)
                .ignoresSafeArea()
            
            
            VStack{
         Text("New Habits")
            .foregroundColor(.orange)
            .font(.title)
            .padding()
            
                Spacer()
           
        Button(action: {
            auth.signInAnonymously{ result, error in
                if error != nil {
                    print("error log in")
                } else{
                    
                    signedIn = true
                }
                
            }
            
          
        }, label: {
            
            Image(systemName: "person.crop.circle.badge.plus")
                .padding(260)
                .foregroundColor(.orange)
                .font(.system(size: 70.0))
                 .padding()
                 
               
                .background(Rectangle()
                    .padding(110)
                            
                    .foregroundColor(.gray)
                            //hörnen blir runda på kortet
                    //.cornerRadius(15)
                    //.shadow(radius: 10)
                )
                    
            
            
            
        })
        .foregroundColor(.gray)
                }
        
            }
            
        }
        
      
    
  
}



struct HabitsView: View {
    
    // Så vi får tag på våran info från viewmodel
   @StateObject var contentVM = ContentVM()
  
    // En bool variabel som ska ge oss en ruta där vi kan skriva in en ny habit
    @State var addHabit = false
    
    // State som kommer ihåg vad vi skriver för vana
    @State var newHabitName = ""
    
    var body: some View {
    
            
            
        Text("New Habits")
            .font(.title2)
            .padding()
            //.background(Rectangle()
             //   .foregroundColor(.white)
                        //hörnen blir runda på kortet
                //.cornerRadius(105)
                //.shadow(radius: 15))
        
        
        VStack {
            
                
                        // Image(systemName: "checkmark.circle")
            //Här ska vi visa upp våra habits i en lista
            List {
                
                 // Och en specifik rad för de olika habits
                 // Den visar varja habit i en egen rad med dess innehåll
                ForEach(contentVM.habits) { habit in
                    // Namnet på vanan och en ruta där vi kan checka av varje dag i vecka
                    // In Hstack så brevid varandra
                    RowView(habit: habit, vm : contentVM)
                    
                        
                    VStack{
                        
                            HStack{
                                
                                
                                Text("Måndag")
                                Spacer()
                                Image(systemName: habit.monday ? "checkmark.circle" :"1.circle")
                                
                            }
                            .foregroundColor(habit.monday ? .green : .black)
                            
                            HStack{
                                Text("Tisdag")
                                Spacer()
                                Image(systemName: habit.tuesday ? "checkmark.circle" :"2.circle")
                                
                            }
                            .foregroundColor(habit.tuesday ? .green : .black)
                            HStack{
                                Text("Onsdag")
                                Spacer()
                                Image(systemName: habit.wednesday ? "checkmark.circle" :"3.circle")
                                
                            }
                            .foregroundColor(habit.wednesday ? .green : .black)
                            HStack{
                                Text("Torsdag")
                                Spacer()
                                Image(systemName: habit.thursday ? "checkmark.circle" :
                                        "4.circle")
                                
                            }
                            .foregroundColor(habit.thursday ? .green : .black)
                            HStack{
                                Text("Fredag")
                                Spacer()
                                Image(systemName: habit.friday ? "checkmark.circle" :"5.circle")
                                
                            }
                            .foregroundColor(habit.friday ? .green : .black)
                            HStack{
                                Text("Lördag")
                                Spacer()
                                Image(systemName: habit.saturday ? "checkmark.circle" :"6.circle")
                                
                            }
                            .foregroundColor(habit.saturday ? .green : .black)
                            HStack{
                                Text("Söndag")
                                Spacer()
                                Image(systemName: habit.sunday ? "checkmark.circle" :"7.circle")
                                
                            }
                            
                            .foregroundColor(habit.sunday ? .green : .black)
                            
                        }
                   

                  
                    
                   }
                // Ger oss möjligheten att radera en "habit" med hjälp av index
                .onDelete(){ indexSet in
                    for index in indexSet {
                        // Vi skickar med vilken plats den som vi raderar är på
                        contentVM.deleteFromFirestoreAndList(index: index)
                    }
                    
                }
               
                    
        }
            // En knapp för att lägga till en ny "habit"
            Button(action: {
                
                addHabit = true
                
            }, label: {
                
                HStack{
                    Image(systemName: "doc.fill.badge.plus")
                        .foregroundColor(.orange)
                        .font(.system(size: 40.0))
                    
                }

            })
            
            .alert("Lägg till en ny vana",isPresented: $addHabit){
                TextField("Lägg till",text: $newHabitName)
                Button("Add" ,action: {
                    contentVM.saveDataToFirestore(nameOfHabit: newHabitName)
                    newHabitName = ""
                    
                   
                })
                
            }
            
        } .onAppear(){
            
            // Här lyssnar den efter ändringar och uppdaterar när den märker av dem
            contentVM.updateAppAndListenToFirestore()
            
            
            
            
        }
        .padding()
        //.foregroundColor(.green)
    }
    
    

struct RowView: View {
    
    let habit : Habit
    let vm : ContentVM
    
    var body: some View {
        HStack{
            // Namnet på våran habit
            Text(habit.newHabit)
            Spacer()
            
            // Text(habit.monday)
            
            
            // Vi ska ha en checkbox för de specifika dagarna som kan ändras
            //checkmark.circle om den är utförd(true) annars en tom cirkel(false).
            Button(action: {
                
                
                vm.toggle(habit: habit)
                
            }, label: {
                // Här visar vi upp bilderna
                // Men om vanan är utförd för den dag så får vi den i checkade bilden
                // Om den är true alltså utförd visas den andra bilden med den i checkade cirkeln
                Image(systemName: habit.done ? "checkmark.circle" : "questionmark.circle.fill")
                
                
            })
            // Färg på titelns checkmarkering
            .foregroundColor(.green)
            
        }
        //Färg på "habits" titeln
        .foregroundColor(.black)
        .font(.title3)
    }
        
}
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
        

}
