//
//  StatisticsViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 13.04.2022.
//

import UIKit

enum StatisticsSectionType: Int {
    case best
    case rps
    case dice
}


final class StatisticsViewController: UIViewController {
    var dataStore:DataStore = DataStore()
    private lazy var dataSource = makeDataSource()
    private let collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewLayoutFactory.statisticsLayout())
        view.backgroundColor = .systemYellow
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        addSubviews()
        makeConstraints()
        createSnapshot()
        configureHeaders()
        configureNavigation()
    }
    
}



extension StatisticsViewController:RPSable{
    func appendRPSResult(round: RPSRound) {
        if(dataStore.diceResults.isEmpty){
            createSnapshot()
        }
        let newItem = dataStore.appendRPSResult(round: round)
        var snapshot = dataSource.snapshot(for: .rps)
        snapshot.append([.init(content: .rps(configuration: .init(id: newItem.id, round: newItem.round)))])
        dataSource.apply(snapshot, to: .dice,animatingDifferences: true)
        updateBestSection()
        
    }
}


extension StatisticsViewController:Diceable{
    func appendDiceResult(imageUrl: String) {
        if(dataStore.diceResults.isEmpty){
            createSnapshot()
        }
        let newItem = dataStore.appendDiceResult(imageUrl: imageUrl)
        var snapshot = dataSource.snapshot(for: .dice)
        snapshot.append([.init(content: .dice(configuration: .init(id: newItem.id, imageUrl: newItem.imageUrl)))])
        dataSource.apply(snapshot, to: .dice,animatingDifferences: true)
        updateBestSection()
    }
    
}


private extension StatisticsViewController {
    var rpsResults: [RPSRoundResult] {
        get{
            return dataStore.rpsResults
        }
    }
    var diceResults: [DiceResult] {
        dataStore.diceResults
    }
    var bestRPSResults:RPSRoundResult?{
        dataStore.bestRPSResults
    }
    var bestDiceResults:[(DiceResult,Float)]{
        dataStore.bestDiceResults
    }
    func addSubviews() {
        view.addSubview(collectionView)
    }
    func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func updateBestSection(){
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.best])
        snapshot.insertSections([.best], beforeSection: .rps)
        if let bestRPSResults = bestRPSResults {
            snapshot.appendItems([
                .init(content: .rps(configuration: .init(id: bestRPSResults.id, round: bestRPSResults.round)))
            ], toSection: .best)
        }
        snapshot.appendItems([
            .init(content: .dicePercentages(configuration: .init(id: 0, statistics: dataStore.bestDiceResults)))
        ], toSection: .best)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    func makeDataSource() -> UICollectionViewDiffableDataSource<StatisticsSectionType, ResultCollectionItem> {
        let dataSource = UICollectionViewDiffableDataSource<
            StatisticsSectionType, ResultCollectionItem
        >(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            
            guard let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else {
                return .init(frame: .zero)
            }
            return self?.createRecentCell(with: item.content, for: indexPath)
        }
        
        return dataSource
    }
    
    func configureNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemYellow
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<StatisticsSectionType, ResultCollectionItem>()
        snapshot.appendSections([.best,.rps,.dice])
        snapshot.appendItems(rpsResults.map { result in
                .init(content: .rps(configuration: .init(id: result.id, round: result.round)))
        }, toSection: .rps)
        snapshot.appendItems(diceResults.map { result in
                .init(content: .dice(
                    configuration: .init(id: result.id, imageUrl: result.imageUrl)
                )
                )
        }, toSection: .dice)
        if let bestRPSResults = bestRPSResults {
            print(bestRPSResults)
            snapshot.appendItems([
                .init(content: .rps(configuration: .init(id: bestRPSResults.id, round: bestRPSResults.round)))
            ], toSection: .best)
        }
        snapshot.appendItems([
            .init(content: .dicePercentages(configuration: .init(id: 0, statistics: bestDiceResults)))
        ], toSection: .best)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    func configureHeaders() {
        var header:UICollectionView.SupplementaryRegistration<HeaderView> = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (supplementaryView, title, indexPath) in
            switch self.dataSource.snapshot().sectionIdentifiers[indexPath.section]{
            case .best:
                supplementaryView.titleLabel.text = "Лучший сет и статистика"
            case .rps:
                supplementaryView.titleLabel.text = "История Rock-Scissors-Paper"
            case .dice:
                supplementaryView.titleLabel.text = "История выпадения кубика"
            }
            supplementaryView.titleLabel.textAlignment = .left
        }
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            let header: HeaderView = collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
            return header
        }
    }
    func createRecentCell(with item: ResultCollectionItem.ItemType, for indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch item {
        case .rps(configuration: let configuration):
            cell.contentConfiguration = configuration
        case .dice(configuration: let configuration):
            cell.contentConfiguration = configuration
        case .dicePercentages(configuration: let configuration):
            cell.contentConfiguration = configuration
        }
        return cell
    }
    
}

final class HeaderView: UICollectionReusableView {
    
    var  titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        addSubview(titleLabel)
        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
