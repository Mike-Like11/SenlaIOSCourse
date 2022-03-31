//
//  DiceGameViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit

enum DiceGameStatus{
    case prepared
    case rolled
    var nextStatus: DiceGameStatus {
        switch self {
        case .prepared: return .rolled
        case .rolled: return .prepared
        }
    }
}


class DiceGameViewController: UIViewController {
    
    private lazy var verticalStackView:UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.axis = .horizontal
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10
        verticalStackView.spacing = UIStackView.spacingUseSystem
        return verticalStackView
    }()
    
    private lazy var optionsStackView:UIStackView = {
        var horizontalStackView = UIStackView()
        horizontalStackView.axis = .vertical
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private lazy var buttonOptions:[UIImageView] = {
        
        var imagesOptions:[UIImageView] = []
        for i in 0...5 {
            let imageView = UIImageView()
            imageView.tag = i
            if let image = UIImage(systemName: "die.face.\(i+1)"){
                imageView.image = image.withRenderingMode(.alwaysOriginal).withTintColor(.black)
                imageView.contentMode = .scaleAspectFit
            }
            imagesOptions.append(imageView)
        }
        return imagesOptions
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.setTitle("Бросок", for: .normal)
        button.tintColor = .systemYellow
        button.addAction(UIAction() { [weak self] _ in
            self?.Roll()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var chosenStackView2:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    private var gameStatus: DiceGameStatus  = .prepared
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.frame = CGRect(x: UIScreen.main.bounds.width/3, y: 5*UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width/3, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}


extension DiceGameViewController{
    func Roll(){
        switch gameStatus {
        case .prepared:
            let randomImageNumber = Int.random(in: 0..<6)
            buttonOptions.forEach { image in
                if !(image.tag == randomImageNumber){
                    image.isHidden = true
                }
            }
            if(randomImageNumber % 2 == 1){
                optionsStackView.isHidden = true
            }
            else{
                chosenStackView2.isHidden = true
            }
            playButton.setTitle("Повтор",for: .normal)
        case .rolled:
            buttonOptions.forEach { image in
                image.isHidden = false
            }
            optionsStackView.isHidden = false
            chosenStackView2.isHidden = false
            playButton.setTitle("Бросок",for: .normal)
        }
        gameStatus = gameStatus.nextStatus
        
    }
    func setupView(){
        view.backgroundColor = .systemYellow
        view.addSubview(verticalStackView)
        view.addSubview(playButton)
        verticalStackView.frame = self.view.bounds.insetBy(dx: 20, dy: 200)
        verticalStackView.addArrangedSubview(optionsStackView)
        verticalStackView.addArrangedSubview(chosenStackView2)
        for i in 0...5{
            if(i % 2==0){
                optionsStackView.addArrangedSubview(buttonOptions[i])
            }
            else{
                chosenStackView2.addArrangedSubview(buttonOptions[i])
            }
        }
    }
}


