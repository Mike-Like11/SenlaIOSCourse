//
//  DataStore.swift
//  SimpleIOSGames
//
//  Created by Mike I on 13.04.2022.
//

import Foundation



protocol RPSable: AnyObject{
    func appendRPSResult(round:RPSRound)
}


protocol Diceable:AnyObject{
    func appendDiceResult(imageUrl:String)
}


final class DataStore{
    
    func appendRPSResult(round:RPSRound)-> RPSRoundResult {
        let item  = RPSRoundResult(id: rpsResults.count, round: round)
        rpsResults.append(item)
        return item
    }
    
    func appendDiceResult(imageUrl: String)-> DiceResult {
        let item  = DiceResult(id: diceResults.count, imageUrl: imageUrl)
        diceResults.append(item)
        return item
    }
    var rpsResults:[RPSRoundResult] = []
    var diceResults:[DiceResult] = []
    var bestRPSResults:RPSRoundResult?
    {
        get{
            var frequency:[RPSRound:Int] = [:]
            rpsResults.forEach { result in
                if(result.round.result == .victory){
                    frequency[result.round] = (frequency[result.round] ?? 0) + 1
                }
            }
            let mostFrequentSet = frequency.sorted(by: {$0.value < $1.value}).last?.key
            return rpsResults.filter({$0.round == mostFrequentSet}).first
        }
    }
    var bestDiceResults:[(DiceResult,Float)]
    {
        get{
            var frequencyArr:[String:(DiceResult,Float)] = [
                "die.face.1":(DiceResult(id: 1, imageUrl: "die.face.1"),0),
                "die.face.2":(DiceResult(id: 2, imageUrl: "die.face.2"),0),
                "die.face.3":(DiceResult(id: 3, imageUrl: "die.face.3"),0),
                "die.face.4":(DiceResult(id: 4, imageUrl: "die.face.4"),0),
                "die.face.5":(DiceResult(id: 5, imageUrl: "die.face.5"),0),
                "die.face.6":(DiceResult(id: 6, imageUrl: "die.face.6"),0),
            ]
            diceResults.forEach { result in
                let updatedValue = (frequencyArr[result.imageUrl]?.1 ?? 0) + (Float(100/Float(diceResults.count)))
                frequencyArr[result.imageUrl]?.1 = updatedValue
            }
            return frequencyArr.sorted(by: {$0.value.0.id < $1.value.0.id}).map{$0.value}
        }
    }
}


struct RPSRoundResult {
    let id: Int
    let round:RPSRound
}


struct DiceResult {
    let id: Int
    let imageUrl: String
}

