//
//  SettingsViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit

enum Lang : Int{
    case rus
    case en
}

enum PlayMode{
    case drawEnabled
    case drawDisabled
}

protocol SettingsViewControllerDelegate: AnyObject {
    
    func changePlayMode(mode:Bool)
    func changeLang(lang:Lang)
    func getLang() -> Lang
    func getPlayMode() -> Bool
}

final class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    private lazy var modeSwitch:UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.addAction(UIAction() { [weak self] _ in
            self?.switchStateDidChange()
        }, for: .valueChanged)
        return mySwitch
    }()
    private var modeLabel:UILabel = {
        let label = UILabel()
        label.text = "Режим ничьи"
        return label
    }()
    private lazy var langSegmentedControl:UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.addAction(UIAction() { [weak self] _ in
            self?.segmentedValueChanged()
        }, for: .valueChanged)
        return segmentedControl
    }()
    private var langLabel:UILabel = {
        let label = UILabel()
        label.text = "Язык"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        setupLangSegmentedControl()
        setupModeSwitch()
        setupNavigationBarIfPossible()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
}


extension SettingsViewController{
    
    func setupView() {
        view.backgroundColor = .systemYellow
        view.addSubview(modeLabel)
        view.addSubview(modeSwitch)
        view.addSubview(langLabel)
        view.addSubview(langSegmentedControl)
    }
    
    func setupLangSegmentedControl(){
        langSegmentedControl.insertSegment(withTitle: "RUS",  at: 0, animated: true)
        langSegmentedControl.insertSegment(withTitle: "EN",  at: 1, animated: true)
        if let delegate = delegate {
            langSegmentedControl.selectedSegmentIndex = delegate.getLang().rawValue
        }
        else{
            langSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    func setupModeSwitch(){
        if let delegate = delegate {
            modeSwitch.setOn(delegate.getPlayMode(), animated: true)
        }
        else{
            modeSwitch.setOn(false, animated: true)
        }
    }
    
    func makeConstraints(){
        langLabel.translatesAutoresizingMaskIntoConstraints = false
        langLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        langLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        langSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        langSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        langSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        modeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        modeSwitch.translatesAutoresizingMaskIntoConstraints = false
        modeSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        modeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    }
    
    func setupNavigationBarIfPossible(){
        self.navigationItem.title = "Настройки"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func segmentedValueChanged() {
        if let  lang = Lang(rawValue: langSegmentedControl.selectedSegmentIndex){
            delegate?.changeLang(lang: lang)
        }
    }
    func switchStateDidChange(){
        
        delegate?.changePlayMode(mode: modeSwitch.isOn)
    }
}
