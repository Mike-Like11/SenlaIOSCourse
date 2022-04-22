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


final class DiceGameViewController: UIViewController {
    
    private var verticalStackView:UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.axis = .horizontal
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10
        return verticalStackView
    }()
    
    private var oddStackView:UIStackView = {
        var horizontalStackView = UIStackView()
        horizontalStackView.axis = .vertical
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private var firstButtonOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 1
        imageView.image = UIImage(systemName: "die.face.1")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var secondButtonOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 2
        imageView.image = UIImage(systemName: "die.face.2")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var thirdButtonOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 3
        imageView.image = UIImage(systemName: "die.face.3")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var fourthButtonOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 4
        imageView.image = UIImage(systemName: "die.face.4")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var fifthButtonOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 5
        imageView.image = UIImage(systemName: "die.face.5")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var sixthButtonOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 6
        imageView.image = UIImage(systemName: "die.face.6")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.setTitle("Бросок", for: .normal)
        button.tintColor = .systemYellow
        button.addAction(UIAction() { [weak self] _ in
            self?.btnRollLogic()
        }, for: .touchUpInside)
        return button
    }()
    
    private var evenStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    weak var delegate: Diceable?
    private var gameStatus: DiceGameStatus  = .prepared
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.frame = CGRect(x: UIScreen.main.bounds.width/3, y: 5*UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width/3, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        addSubviews()
        makeConstraints()
    }
}


private extension DiceGameViewController{
    
    func makeRandomRoll(){
        let randomImageNumber = Int.random(in: 1..<7)
        firstButtonOption.isHidden = true
        secondButtonOption.isHidden = true
        thirdButtonOption.isHidden = true
        fourthButtonOption.isHidden = true
        fifthButtonOption.isHidden = true
        sixthButtonOption.isHidden = true
        switch randomImageNumber{
        case 1:
            firstButtonOption.isHidden = false
            delegate?.appendDiceResult(imageUrl: "die.face.1")
        case 2:
            secondButtonOption.isHidden = false
            delegate?.appendDiceResult(imageUrl: "die.face.2")
        case 3:
            thirdButtonOption.isHidden = false
            delegate?.appendDiceResult(imageUrl: "die.face.3")
        case 4:
            fourthButtonOption.isHidden = false
            delegate?.appendDiceResult(imageUrl: "die.face.4")
        case 5:
            fifthButtonOption.isHidden = false
            delegate?.appendDiceResult(imageUrl: "die.face.5")
        case 6:
            sixthButtonOption.isHidden = false
            delegate?.appendDiceResult(imageUrl: "die.face.6")
        default:
            break
        }
        if(randomImageNumber % 2 == 0){
            oddStackView.isHidden = true
        }
        else{
            evenStackView.isHidden = true
        }
        playButton.setTitle("Повтор",for: .normal)
    }
    func prepareToRoll(){
        firstButtonOption.isHidden = false
        secondButtonOption.isHidden = false
        thirdButtonOption.isHidden = false
        fourthButtonOption.isHidden = false
        fifthButtonOption.isHidden = false
        sixthButtonOption.isHidden = false
        oddStackView.isHidden = false
        evenStackView.isHidden = false
        playButton.setTitle("Бросок",for: .normal)
    }
    func btnRollLogic(){
        switch gameStatus {
        case .prepared:
            makeRandomRoll()
        case .rolled:
            prepareToRoll()
        }
        gameStatus = gameStatus.nextStatus
        
    }
    func  addSubviews(){
        view.addSubview(verticalStackView)
        view.addSubview(playButton)
        verticalStackView.addArrangedSubview(oddStackView)
        verticalStackView.addArrangedSubview(evenStackView)
        oddStackView.addArrangedSubview(firstButtonOption)
        evenStackView.addArrangedSubview(secondButtonOption)
        oddStackView.addArrangedSubview(thirdButtonOption)
        evenStackView.addArrangedSubview(fourthButtonOption)
        oddStackView.addArrangedSubview(fifthButtonOption)
        evenStackView.addArrangedSubview(sixthButtonOption)
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
}


