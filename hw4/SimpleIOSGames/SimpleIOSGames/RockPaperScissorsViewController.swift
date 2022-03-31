//
//  RockPaperScissorsViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit

protocol RockPaperScissorsable: AnyObject {
    
    func changePlayMode(mode:Bool)
    func changeLang(lang:Int)
    var playMode:Bool { get set }
    var lang:Int { get set }
}

class RockPaperScissorsViewController: UIViewController,RockPaperScissorsable {
    var playMode: Bool = false
    var lang: Int = 0
    var result:Int = 0
    var resultOptions:[(String,String)] = [("",""),("Поражение","Lose"),("Ничья","Draw"),("Победа","Victory")]
    
    private lazy var yourChoosenImage:UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "Rock"){
            imageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var opponentChoosenImage:UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "Rock"){
            imageView.image = image.withRenderingMode(.alwaysOriginal)
        }
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
    
    private lazy var buttonOptions:[UIButton] = {
        
        var buttonOptions:[UIButton] = []
        if let image = UIImage(named: "Rock"){
            imageOptions.append(image.withRenderingMode(.alwaysOriginal))
        }
        if let image = UIImage(named: "Scissors"){
            imageOptions.append(image.withRenderingMode(.alwaysOriginal))
        }
        if let image = UIImage(named: "Paper"){
            imageOptions.append(image.withRenderingMode(.alwaysOriginal))
        }
        for i in 0...2 {
            let button = UIButton(type: .roundedRect)
            button.contentMode = .scaleAspectFit
            button.setImage(imageOptions[i], for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tag = i
            button.addTarget(self, action: #selector(RockPaperScissorsViewController.makeMove(_:)), for: .touchUpInside)
            buttonOptions.append(button)
        }
        return buttonOptions
    }()
    
    private lazy var imageOptions:[UIImage] = []
    
    private lazy var verticalStackView:UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 40
        verticalStackView.spacing = UIStackView.spacingUseSystem
        return verticalStackView
    }()
    
    private lazy var optionsStackView:UIStackView = {
        var horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 40
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private lazy var chosenStackView2:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 90
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var resultLabel: UILabel = {
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.frame = CGRect(x: UIScreen.main.bounds.width/3, y: 5*UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width/3, height: 50)
    }
    
    
}
extension RockPaperScissorsViewController{
    
    func setupView() {
        view.backgroundColor = .systemYellow
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(resultLabel)
        verticalStackView.frame = self.view.bounds.insetBy(dx: 20, dy: 200)
        chosenStackView2.addArrangedSubview(yourChoosenImage)
        chosenStackView2.addArrangedSubview(opponentChoosenImage)
        verticalStackView.addArrangedSubview(chosenStackView2)
        verticalStackView.addArrangedSubview(optionsStackView)
        buttonOptions.forEach {button in
            optionsStackView.addArrangedSubview(button)
        }
        setupLangResult()
        setupLangButton()
        view.addSubview(playButton)
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
    
    @objc func makeMove(_ sender:UIButton!){
        var randomImageNumber:Int
        if(!playMode){
            randomImageNumber = Int.random(in: sender.tag+1..<sender.tag+3) % 3
        }
        else{
            randomImageNumber = Int.random(in: 0..<3)
        }
        self.optionsStackView.isHidden = true
        UIView .transition(with:  (self.opponentChoosenImage), duration: 1, options: .transitionFlipFromLeft,
                           animations: { [self] in
            self.opponentChoosenImage.image = self.imageOptions[randomImageNumber]
        }, completion: nil)
        UIView .transition(with:  (self.yourChoosenImage), duration: 1, options: .transitionFlipFromRight,
                           animations: {
            self.yourChoosenImage.image = sender.imageView?.image
        }, completion: nil)
        self.yourChoosenImage.image = sender.imageView?.image
        self.buttonOptions.forEach { button in
            button.isEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                self.resultLabel.isHidden = false
                if(randomImageNumber - sender.tag == 1 || (sender.tag == 2 && randomImageNumber == 0)){
                    self.result = 3
                }
                else{
                    if(randomImageNumber == sender.tag){
                        self.result = 2
                    }
                    else {
                        self.result = 1
                    }
                }
                self.setupLangResult()
                self.playButton.isHidden  = false
            })
        }
        
    }
    
    func gameOn(){
        buttonOptions.forEach { button in
            button.isEnabled = true
        }
        resultLabel.isHidden = true
        playButton.isHidden  = true
        if let image = UIImage(named: "Rock"){
            yourChoosenImage.image = image.withRenderingMode(.alwaysOriginal)
            opponentChoosenImage.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.optionsStackView.isHidden = false
        self.playButton.isHidden  = true
    }
    
    func setupLangButton(){
        switch(lang){
        case 0:
            playButton.setTitle("Играть снова", for: .normal)
        case 1:
            playButton.setTitle("Play Again", for: .normal)
        default:
            playButton.setTitle("Играть снова", for: .normal)
        }
    }
    
    func setupLangResult(){
        switch(lang){
        case 0:
            resultLabel.text = resultOptions[result].0
        case 1:
            resultLabel.text = resultOptions[result].1
        default:
            resultLabel.text = ""
        }
    }
    func changePlayMode(mode: Bool) {
        playMode = mode
    }
    func changeLang(lang: Int) {
        self.lang = lang
        setupLangButton()
        setupLangResult()
    }
}
