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
    
    // Här räknar vi streaken
    var streak : Int
    
    // När vi trycker på knappen ökar antalet i streaken
    var isPressed : Bool = true
    
    // Om en vanan är uppnåd under en dag ska den kunna
    var done : Bool = true

 
    
    
}
