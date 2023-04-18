//
//  Habit.swift
//  newHabits
//
//  Created by A on 2023-04-18.
//

import Foundation
import FirebaseFirestoreSwift

// en modell som kapslar in habits och vad som ska ingå i en habit
struct Habit : Codable, Identifiable{
    
    // När vi laddar ner våran info ska den få den specifika id:t
    // id skapas när det laddas up eller ner
    @DocumentID var id : String?
    
    // Här skriver vi in våran vana
    var newHabit : String 
    // Alla bool har false pga att vi ej har uppnåt en dag än.
    var monday : Bool = false
    var tuesday : Bool = false
    var wednesday : Bool = false
    var thursday : Bool = false
    var friday : Bool = false
    var saturday : Bool = false
    var sunday : Bool = false
    // Om en vanan är uppnåd under en dag ska den kunna
    var done : Bool = true
    
}
