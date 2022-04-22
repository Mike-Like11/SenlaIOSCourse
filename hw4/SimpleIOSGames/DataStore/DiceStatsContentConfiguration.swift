//
//  DiceStatsContentConfiguration.swift
//  SimpleIOSGames
//
//  Created by Mike I on 15.04.2022.
//

import UIKit

struct DiceStatsContentConfiguration: UIContentConfiguration {
    let id:Int
    let statistics:[(DiceResult,Float)]
    func makeContentView() -> UIView & UIContentView {
        DiceStatsContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
    
    
}

final class DiceStatsContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration
    
    
    private let verticalStackView:UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.axis = .horizontal
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10
        return verticalStackView
    }()
    
    private let oddImageStackView:UIStackView = {
        var horizontalStackView = UIStackView()
        horizontalStackView.axis = .vertical
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private let oddLabelStackView:UIStackView = {
        var horizontalStackView = UIStackView()
        horizontalStackView.axis = .vertical
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private let firstImageOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 1
        imageView.image = UIImage(systemName: "die.face.1")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let firstImagePercentage:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let secondImagePercentage:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let thirdImagePercentage:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let fifthImagePercentage:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let fourthImagePercentage:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let sixthImagePercentage:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let secondImageOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 2
        imageView.image = UIImage(systemName: "die.face.2")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let thirdImageOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 3
        imageView.image = UIImage(systemName: "die.face.3")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let fourthImageOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 4
        imageView.image = UIImage(systemName: "die.face.4")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let fifthImageOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 5
        imageView.image = UIImage(systemName: "die.face.5")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let sixthImageOption:UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 6
        imageView.image = UIImage(systemName: "die.face.6")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let evenImageStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let evenLabelStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    init(with contentConfiguration: DiceStatsContentConfiguration) {
        configuration = contentConfiguration
        super.init(frame: .zero)
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8.0
        layer.shadowOffset = .zero
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(oddImageStackView)
        verticalStackView.addArrangedSubview(oddLabelStackView)
        verticalStackView.addArrangedSubview(evenImageStackView)
        verticalStackView.addArrangedSubview(evenLabelStackView)
        oddImageStackView.addArrangedSubview(firstImageOption)
        oddImageStackView.addArrangedSubview(thirdImageOption)
        oddImageStackView.addArrangedSubview(fifthImageOption)
        evenImageStackView.addArrangedSubview(secondImageOption)
        evenImageStackView.addArrangedSubview(fourthImageOption)
        evenImageStackView.addArrangedSubview(sixthImageOption)
        oddLabelStackView.addArrangedSubview(firstImagePercentage)
        oddLabelStackView.addArrangedSubview(thirdImagePercentage)
        oddLabelStackView.addArrangedSubview(fifthImagePercentage)
        evenLabelStackView.addArrangedSubview(secondImagePercentage)
        evenLabelStackView.addArrangedSubview(fourthImagePercentage)
        evenLabelStackView.addArrangedSubview(sixthImagePercentage)
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let content = configuration as? DiceStatsContentConfiguration else {
            return
        }
        firstImagePercentage.text = "\(Int(content.statistics[0].1)) %"
        secondImagePercentage.text = "\(Int(content.statistics[1].1)) %"
        thirdImagePercentage.text = "\(Int(content.statistics[2].1)) %"
        fourthImagePercentage.text = "\(Int(content.statistics[3].1)) %"
        fifthImagePercentage.text = "\(Int(content.statistics[4].1)) %"
        sixthImagePercentage.text = "\(Int(content.statistics[5].1)) %"
    }
    
    private func makeConstraints() {
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
}
