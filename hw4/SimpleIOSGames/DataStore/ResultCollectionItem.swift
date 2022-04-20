//
//  ResultCollectionItem.swift
//  SimpleIOSGames
//
//  Created by Mike I on 13.04.2022.
//

import Foundation

struct ResultCollectionItem: Hashable {
    let uuid = UUID()
    
    enum ItemType{
        case rps(configuration: RPSResultContentConfiguration)
        case dice(configuration: DiceResultContentConfiguration)
        case dicePercentages(configuration: DiceStatsContentConfiguration)
    }
    
    let content: ItemType
    
    init(content: ItemType) {
        self.content = content
    }
    
    static func == (lhs: ResultCollectionItem, rhs: ResultCollectionItem) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
