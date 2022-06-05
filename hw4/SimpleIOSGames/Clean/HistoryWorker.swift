//
//  HistoryWorker.swift
//  SimpleIOSGames
//
//  Created by Mike I on 03.06.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class HistoryWorker
{
    var dataStore: DataStore
    
    init(dataStore:DataStore)
    {
        self.dataStore = dataStore
    }
    func appendDiceResult(imageUrl:String) -> DiceResult
    {
        let newItem = dataStore.appendDiceResult(imageUrl: imageUrl)
        return newItem
    }
    func getListDiceResult() -> [DiceResult]
    {
        return dataStore.diceResults
    }
    func appendRPSResult(round: RPSRound) -> RPSRoundResult
    {
        let newItem = dataStore.appendRPSResult(round: round)
        return newItem
    }
    func getListRPSResult() -> [RPSRoundResult]
    {
        return dataStore.rpsResults
    }
    func getBestRPSResults() -> RPSRoundResult?
    {
        return dataStore.bestRPSResults
    }
    func getBestDiceResults() -> [(DiceResult,Float)]
    {
        return dataStore.bestDiceResults
    }
}