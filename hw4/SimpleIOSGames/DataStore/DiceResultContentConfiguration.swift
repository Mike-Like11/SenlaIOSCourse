//
//  DiceResultContentConfiguration.swift
//  SimpleIOSGames
//
//  Created by Mike I on 14.04.2022.
//

import UIKit

struct DiceResultContentConfiguration: UIContentConfiguration {
    
    let id: Int
    let imageUrl:String
    
    func makeContentView() -> UIView & UIContentView {
        DiceResultContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> DiceResultContentConfiguration {
        self
    }
}

final class DiceResultContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration
    
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemYellow
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    init(with contentConfiguration: DiceResultContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .zero)
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8.0
        layer.shadowOffset = .zero
        addSubview(image)
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let content = configuration as? DiceResultContentConfiguration else {
            return
        }
        image.image = UIImage(systemName: content.imageUrl)
    }
    
    private func makeConstraints() {
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leftAnchor.constraint(equalTo: leftAnchor),
            image.rightAnchor.constraint(equalTo: rightAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}
