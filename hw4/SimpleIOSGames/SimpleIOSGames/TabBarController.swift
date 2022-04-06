//
//  TabBarController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isOpaque = true
        tabBar.tintColor = .systemYellow
        tabBar.unselectedItemTintColor = .white
        tabBar.backgroundColor = .black
        setupTabBar()
    }
}


private extension TabBarController {
    
    func setupTabBar() {
        
        let navRockPaperScissors = UINavigationController(
            rootViewController: RockPaperScissorsViewController()
        )
        let navCDiceGame = UINavigationController(
            rootViewController: DiceGameViewController()
        )
        
        
        navRockPaperScissors.tabBarItem = UITabBarItem(
            title: "RockPaperScissors",
            image: UIImage(
                systemName: "gamecontroller"
            ),
            tag: 0
        )
        
        navCDiceGame.tabBarItem = UITabBarItem(
            title: "DiceGame",
            image: UIImage(
                systemName: "dice"
            ),
            tag: 1)
        
        setViewControllers([
            navRockPaperScissors, navCDiceGame
        ], animated: true)
    }
}
