//
//  DiceGameRouter.swift
//  SimpleIOSGames
//
//  Created by Mike I on 22.06.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit



protocol DiceGameDataPassing
{
  var dataStore: DiceGameDataStore? { get }
}

class DiceGameRouter: NSObject,  DiceGameDataPassing
{
  weak var viewController: DiceGameViewController?
  var dataStore: DiceGameDataStore?

}