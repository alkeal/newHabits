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
    
    @StateObject var contentVM = ContentVM()
    var body: some View {
        
        if !signedIn {
            // dollartecken om man ska skicka med hela statet
            StartPageView(signedIn: $signedIn)
                
        } else{
            HabitsView()    //(vm : contentVM)
        }
            
        
    }
    
}


struct StartPageView : View {
    
    // då vi måste skicka med hela
   @Binding var signedIn : Bool
    
    var auth = Auth.auth()
    
    
    var body: some View {
        
        ZStack{
            
    
            
            VStack{
                
                Spacer()
                    .padding(80)
                
            Image("NewHabitsStartPage")
                    .padding(-100)
           
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
                .padding(130)
                .foregroundColor(.orange)
                .font(.system(size: 60.0))
                 .padding()
               
            
                .background(Rectangle()
                    .padding(110)
                    .foregroundColor(.white))
                          
                    
            
            
            
        })
        .foregroundColor(Color(hue: 120, saturation: 138, brightness: 168))
        
                
     
                              }
        
            }
            
        }
    
  
}



struct HabitsView: View {
    
    // Så vi får tag på våran info från viewmodel
    @StateObject var contentVM = ContentVM()
    
    // En bool variabel som ska ge oss en ruta där vi kan skriva in en ny habit
    @State var addHabit = false
    
    @State var streak = 1
    // State som kommer ihåg vad vi skriver för vana
    @State var newHabitName = ""
    

    //let vm : ContentVM
    
    var body: some View {
        
   
        NavigationView{
            
            VStack{
                
           HStack{
            
            
            Spacer()
            Image("NewHabitsBanner")
                .padding(15)
                .aspectRatio( contentMode: .fit )
           
            // Knapp som ska skicka oss till inställningarna
             Button(action: {
                 //NavigationLink(destination: StartPageView(signedIn: signedIn){
                 //StartPageView(signedIn: signedIn), label: "")
                 
             }, label: {
                 HStack{
                 Image(systemName: "ellipsis.rectangle.fill")
                     .foregroundColor(.orange)
                     .font(.system(size: 25.0))
                     .padding(10)
                   }
                 
                })
                    
                   
            }
            
                //Här ska vi visa upp våra habits i en lista
                List {
                    
                    // Och en specifik rad för de olika habits
                    
                    ForEach(contentVM.habits) { habit in
                        
                        // In Hstack så brevid varandra
                        RowView(habit: habit, vm : contentVM)
                        
                        
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
                            .font(.system(size: 35.0))
                        
                    }
                    
                })
                
                .alert("Lägg till en ny vana",isPresented: $addHabit){
                    
                    TextField("Skriv här",text: $newHabitName)
                    Button("Spara" ,action: {
                        
                        contentVM.saveDataToFirestore(nameOfHabit: newHabitName)
                        newHabitName = ""
                        
                        
                    })
                    Button("Släng",action:{
                        addHabit = false
                    })
                    
                }
                
                
                .foregroundColor(Color(hue: 127, saturation: 146, brightness: 168))
                
            } .onAppear(){
                
                // Här lyssnar den efter ändringar och uppdaterar när den märker av dem
                contentVM.updateAppAndListenToFirestore()
                
                
                
                
            }
            
            
            .background(Rectangle()
                .foregroundColor(.white)
                        
                .cornerRadius(0)
                .shadow(radius: 0))
            
        }
           
    }
    
    
    
    struct RowView: View {
        
        var habit : Habit
        let vm : ContentVM
        
        
        
        var body: some View {
            
            HStack{
                // Namnet på våran habit
                Text(habit.newHabit)
                    .font(.title3)
                
                Spacer()
                
                
                Button(action: {
                    
                    
                    vm.toggle(habit: habit)
                    
                    
                }, label: {
                    // Här visar vi upp bilderna
                    // Om den är true alltså utförd visas den andra bilden med den i checkade cirkeln
                    Image(systemName: habit.done ?   "checkmark.square.fill":"plus.app")
                        .font(.system(size: 25.0))
                        .foregroundColor(.green)
                })
                
                
            }
            .padding()
            .background(Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2))
            
            ZStack{
                
                
                Text("Nuvarande streak : " + String(habit.streak) + " dagar ")
                    .padding()
                    .background(Rectangle()
                        .foregroundColor(.white)
                                
                        .cornerRadius(10)
                                
                    )
                
            }
            //Färg på "habits" titeln
            .foregroundColor(.black)
            .font(.title3)
            
        }
        
    }
    
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            //ContentView()
            HabitsView(contentVM: ContentVM())
        }
    }
        





