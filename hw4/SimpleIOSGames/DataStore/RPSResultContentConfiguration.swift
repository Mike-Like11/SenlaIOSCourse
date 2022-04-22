//
//  RPSContentConfiguration.swift
//  SimpleIOSGames
//
//  Created by Mike I on 13.04.2022.
//

import UIKit

struct RPSResultContentConfiguration: UIContentConfiguration {
    let id: Int
    let round:RPSRound
    
    func makeContentView() -> UIView & UIContentView {
        RPSResultContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> RPSResultContentConfiguration {
        self
    }
}


final class RPSResultContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration
    var languageResults:TranslatedResults = russianResults()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let yourImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .red
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private let opponentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private let chosenStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 90
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(with contentConfiguration: RPSResultContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .zero)
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8.0
        layer.shadowOffset = .zero
        addSubview(chosenStackView)
        chosenStackView.addArrangedSubview(yourImageView)
        chosenStackView.addArrangedSubview(label)
        chosenStackView.addArrangedSubview(opponentImageView)
        addSubview(label)
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let content = configuration as? RPSResultContentConfiguration else {
            return
        }
        switch content.round.result{
        case .victory:
            backgroundColor = .systemGreen
        case .draw:
            backgroundColor = .systemRed
        case .lose:
            backgroundColor = .black
        case .process: break
        }
        label.text = languageResults.getTranslatedResults(result: content.round.result)
        yourImageView.image = UIImage(named: content.round.youChoice.getImageUrl())
        opponentImageView.image = UIImage(named: content.round.opponentChoice.getImageUrl())
    }
    
    private func makeConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        chosenStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chosenStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 60),
            chosenStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            chosenStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            chosenStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -30),
            label.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 30)
            
        ])
    }
}

