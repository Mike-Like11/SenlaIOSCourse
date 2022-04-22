//
//  RockPaperScissorsViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit


enum Result{
    case process
    case victory
    case draw
    case lose
}


enum RPSVariants:Int{
    case rock
    case scissors
    case paper
    case none
    func getImageUrl() -> String{
        switch self {
        case .rock:
            return "Rock"
        case .paper:
            return "Paper"
        case .scissors:
            return "Scissors"
        case.none:
            return ""
        }
    }
}


struct RPSRound:Hashable{
    var result:Result = .process
    var youChoice:RPSVariants = .none
    var opponentChoice:RPSVariants = .none
}


protocol TranslatedResults{
    func getTranslatedResults(result:Result)->String
    func getTranslatedButtonText() -> String
}


struct russianResults:  TranslatedResults{
    
    func getTranslatedResults(result:Result) -> String{
        switch result {
        case .process:
            return ""
        case .victory:
            return "Победа 😊"
        case .draw:
            return "Ничья 😐"
        case .lose:
            return "Проигрыш 😔"
        }
    }
    func getTranslatedButtonText() -> String{
        return "Играть снова"
    }
}


struct englishResults:  TranslatedResults{
    
    func getTranslatedResults(result:Result) -> String{
        switch result {
        case .process:
            return ""
        case .victory:
            return "Victory 😊"
        case .draw:
            return "Draw 😐"
        case .lose:
            return "Lose 😔"
        }
    }
    func getTranslatedButtonText() -> String{
        return "Play Again"
    }
}


final class RockPaperScissorsViewController: UIViewController {

    var playMode: PlayMode = .drawDisabled
    var lang: Lang = .rus
    var round = RPSRound()
    var languageResults:TranslatedResults = russianResults()
    private var yourChoosenImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var opponentChoosenImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.isHidden  = true
        button.addAction(UIAction() { [weak self] _ in
            self?.gameOn()
        }, for: .touchUpInside)
        return button
    }()
    
    
    private var rockButtonOption:UIButton = {
        let button = UIButton(type: .roundedRect)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 0
        button.addTarget(self, action: #selector(RockPaperScissorsViewController.makeMove(_:)), for: .touchUpInside)
        return button
    }()
    private var scissorsButtonOption:UIButton = {
        let button = UIButton(type: .roundedRect)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "Scissors")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 1
        button.addTarget(self, action: #selector(RockPaperScissorsViewController.makeMove(_:)), for: .touchUpInside)
        return button
    }()
    private var paperButtonOption:UIButton = {
        let button = UIButton(type: .roundedRect)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "Paper")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 2
        button.addTarget(self, action: #selector(RockPaperScissorsViewController.makeMove(_:)), for: .touchUpInside)
        return button
    }()
    private var imageSrcOptions:[String] = ["Rock", "Scissors", "Paper"]
    
    private var verticalStackView:UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 40
        verticalStackView.spacing = UIStackView.spacingUseSystem
        return verticalStackView
    }()
    
    private var optionsStackView:UIStackView = {
        var horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 40
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private var chosenStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 90
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.font = .systemFont(ofSize: 32)
        resultLabel.textColor = .systemIndigo
        resultLabel.isHidden = true
        return resultLabel
    }()
    weak var delegate: RPSable?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarIfPossible()
        setupView()
        makeConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.frame = CGRect(x: UIScreen.main.bounds.width/3, y: 5*UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width/3, height: 50)
    }
    
    
}

extension RockPaperScissorsViewController:SettingsViewControllerDelegate{
    
    func changePlayMode(mode: Bool) {
        playMode = mode ? .drawEnabled : .drawDisabled
    }
    
    func changeLang(lang: Lang) {
        self.lang = lang
        switch lang {
        case .rus:
            languageResults = russianResults()
        case .en:
            languageResults = englishResults()
        }
        setupLangButton()
        setupLangResult()
    }
    
    func getLang() -> Lang {
        return lang
    }
    
    func getPlayMode() -> Bool {
        switch playMode{
            
        case .drawEnabled:
            return true
        case .drawDisabled:
            return false
        }
    }
}

private extension RockPaperScissorsViewController{
    
    func setupView() {
        view.backgroundColor = .systemYellow
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(resultLabel)
        chosenStackView.addArrangedSubview(yourChoosenImage)
        chosenStackView.addArrangedSubview(opponentChoosenImage)
        verticalStackView.addArrangedSubview(chosenStackView)
        verticalStackView.addArrangedSubview(optionsStackView)
        optionsStackView.addArrangedSubview(rockButtonOption)
        optionsStackView.addArrangedSubview(scissorsButtonOption)
        optionsStackView.addArrangedSubview(paperButtonOption)
        setupLangResult()
        setupLangButton()
        view.addSubview(playButton)
    }
    
    func  makeConstraints(){
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor,constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            verticalStackView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor,constant: -200),
        ])
    }
    
    func setupNavigationBarIfPossible() {
        navigationItem.title = "Камень-Ножницы-Бумага"
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "gearshape.fill",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)),
            for: .normal)
        button.imageView?.tintColor = .black
        button.addAction(UIAction() { [weak self] _ in
            self?.openSettings()
        }, for: .touchUpInside)
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(customView: button) ]
    }
    
    func openSettings(){
        let settingViewController = SettingsViewController()
        settingViewController.delegate = self
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    func resultCalculation(yourChoiceNumber:Int){
        var opponentChoiceNumber:Int
        switch playMode{
        case .drawEnabled:
            opponentChoiceNumber = Int.random(in: 0..<3)
        case .drawDisabled:
            opponentChoiceNumber = Int.random(in: yourChoiceNumber+1..<yourChoiceNumber+3) % 3
        }
        if(opponentChoiceNumber - yourChoiceNumber == 1 || (yourChoiceNumber == 2 && opponentChoiceNumber == 0)){
            self.round.result = .victory
        }
        else{
            if(opponentChoiceNumber == yourChoiceNumber){
                self.round.result = .draw
            }
            
            else {
                self.round.result = .lose
            }
        }
        if let yourChoice = RPSVariants(rawValue: yourChoiceNumber){
            round.youChoice = yourChoice
        }
        if let opponentChoice = RPSVariants(rawValue: opponentChoiceNumber){
            round.opponentChoice = opponentChoice
        }
        delegate?.appendRPSResult(round: round)
    }
    
    @objc func makeMove(_ sender:UIButton){
        resultCalculation(yourChoiceNumber: sender.tag)
        self.optionsStackView.isHidden = true
        UIView .transition(with:  (self.opponentChoosenImage), duration: 1, options: .transitionFlipFromLeft,
                           animations: { [self] in
            
            self.opponentChoosenImage.image = UIImage(named: round.opponentChoice.getImageUrl())?.withRenderingMode(.alwaysOriginal)
        }, completion: nil)
        UIView .transition(with:  (self.yourChoosenImage), duration: 1, options: .transitionFlipFromRight,
                           animations: {
            self.yourChoosenImage.image = sender.imageView?.image
        }, completion: nil)
        self.yourChoosenImage.image = sender.imageView?.image
        
        UIView.animate(withDuration: 0.2,
                       delay: 1,
                       options: .curveLinear,
                       animations: {
            self.resultLabel.isHidden = false
            
            self.playButton.isHidden  = false
        })
        self.setupLangResult()
        
    }
    
    func gameOn(){
        resultLabel.isHidden = true
        playButton.isHidden  = true
        round.result = .process
        round.opponentChoice = .none
        round.youChoice = .none
        yourChoosenImage.image = UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal)
        opponentChoosenImage.image = UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal)
        optionsStackView.isHidden = false
        playButton.isHidden  = true
    }
    
    func setupLangButton(){
        playButton.setTitle(languageResults.getTranslatedButtonText(), for: .normal)
    }
    
    func setupLangResult(){
        resultLabel.text = languageResults.getTranslatedResults(result: round.result)
    }
    
    
}
