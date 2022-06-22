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



protocol AppendDiceLogic: AnyObject
{
    func appendDiceResult(imageUrl:String)
}


protocol DiceGameDisplayLogic: AnyObject
{
    func displayNewDiceResult(viewModel: DiceGame.AppendDiceResult.ViewModel)
}


final class DiceGameViewController: UIViewController {
    var interactor: DiceGameBusinessLogic?
    var router: (NSObjectProtocol  & DiceGameDataPassing)?
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
    var delegate: HistoryAppendDiceDisplayLogic?
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
    
    init(dataStore: DataStore) {
        super.init(nibName: nil, bundle: nil)
        setup(dataStore: dataStore)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(dataStore: DataStore)
    {
        let viewController = self
        let interactor = DiceGameInteractor()
        let presenter = DiceGamePresenter()
        interactor.worker = DiceGameWorker(dataStore: dataStore)
        let router = DiceGameRouter()
        viewController.interactor = interactor
        viewController.router = router as! NSObjectProtocol & DiceGameDataPassing
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}


extension DiceGameViewController: AppendDiceLogic{
    
    func appendDiceResult(imageUrl: String)
    {
        interactor?.appendDiceResult(request: DiceGame.AppendDiceResult.Request(imageUrl: imageUrl))
    }
}


extension DiceGameViewController: DiceGameDisplayLogic{
    
    func displayNewDiceResult(viewModel: DiceGame.AppendDiceResult.ViewModel)
    {
        delegate?.displayNewDiceResult(viewModel: viewModel)
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
        var imageUrl = ""
        switch randomImageNumber{
        case 1:
            firstButtonOption.isHidden = false
            imageUrl = "die.face.1"
        case 2:
            secondButtonOption.isHidden = false
            imageUrl = "die.face.2"
        case 3:
            thirdButtonOption.isHidden = false
            imageUrl = "die.face.3"
        case 4:
            fourthButtonOption.isHidden = false
            imageUrl = "die.face.4"
        case 5:
            fifthButtonOption.isHidden = false
            imageUrl = "die.face.5"
        case 6:
            sixthButtonOption.isHidden = false
            imageUrl = "die.face.6"
        default:
            break
        }
        appendDiceResult(imageUrl: imageUrl)
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


