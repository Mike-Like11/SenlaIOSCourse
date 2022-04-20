//
//  TabBarController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    private let dataStore = DataStore()
    
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
        setupTabBar()
    }
}


private extension TabBarController {
    
    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance  = appearance
        tabBar.isOpaque = false
        tabBar.tintColor = .systemYellow
        tabBar.unselectedItemTintColor = .white
        let statisitcsViewController = StatisticsViewController()
        let rpsViewController = RockPaperScissorsViewController()
        let diceGameViewController = DiceGameViewController()
        rpsViewController.delegate = statisitcsViewController
        diceGameViewController.delegate = statisitcsViewController
        let navRockPaperScissors = UINavigationController(
            rootViewController: rpsViewController
        )
        let navCDiceGame = UINavigationController(
            rootViewController: diceGameViewController
        )
        let navStatistics = UINavigationController(
            rootViewController: statisitcsViewController
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
        
        navStatistics.tabBarItem = UITabBarItem(
            title: "Statistics",
            image: UIImage(
                systemName: "list.bullet.rectangle"
            ),
            tag: 2)
        setViewControllers([
            navRockPaperScissors, navCDiceGame, navStatistics
        ], animated: true)
    }
}
