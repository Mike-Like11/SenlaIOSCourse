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

class RockPaperScissorsViewController: UIViewController {

    var playMode: PlayMode = .drawDisabled
    var lang: Lang = .rus
    var result:Result = .process
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
    
    @objc func makeMove(_ sender:UIButton){
        var randomImageNumber:Int
        switch playMode{
        case .drawEnabled:
            randomImageNumber = Int.random(in: 0..<3)
        case .drawDisabled:
            randomImageNumber = Int.random(in: sender.tag+1..<sender.tag+3) % 3
        }
        self.optionsStackView.isHidden = true
        UIView .transition(with:  (self.opponentChoosenImage), duration: 1, options: .transitionFlipFromLeft,
                           animations: { [self] in
            self.opponentChoosenImage.image = UIImage(named: self.imageSrcOptions[randomImageNumber])?.withRenderingMode(.alwaysOriginal)
        }, completion: nil)
        UIView .transition(with:  (self.yourChoosenImage), duration: 1, options: .transitionFlipFromRight,
                           animations: {
            self.yourChoosenImage.image = sender.imageView?.image
        }, completion: nil)
        self.yourChoosenImage.image = sender.imageView?.image
        if(randomImageNumber - sender.tag == 1 || (sender.tag == 2 && randomImageNumber == 0)){
            self.result = .victory
        }
        else{
            if(randomImageNumber == sender.tag){
                self.result = .draw
            }
            
            else {
                self.result = .lose
            }
        }
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
        result = .process
        yourChoosenImage.image = UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal)
        opponentChoosenImage.image = UIImage(named: "Rock")?.withRenderingMode(.alwaysOriginal)
        optionsStackView.isHidden = false
        playButton.isHidden  = true
    }
    
    func setupLangButton(){
        playButton.setTitle(languageResults.getTranslatedButtonText(), for: .normal)
    }
    
    func setupLangResult(){
        resultLabel.text = languageResults.getTranslatedResults(result: result)
    }
    
    
    func changeResult(result: Result) {
        self.result = result
    }
    
}
