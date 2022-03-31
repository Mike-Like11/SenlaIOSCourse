//
//  SettingsViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 30.03.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: RockPaperScissorsable?
    
    private lazy var modeSwitch:UISwitch = {
        
        let mySwitch = UISwitch()
        if let delegate = delegate {
            mySwitch.setOn(delegate.playMode, animated: true)
        }
        else{
            mySwitch.setOn(false, animated: true)
        }
        mySwitch.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        return mySwitch
    }()
    
    private lazy var modeLabel:UILabel = {
        let label = UILabel()
        label.text = "Режим ничьи"
        return label
    }()

    private lazy var langSegmentedControl:UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["RUS", "EN"])
        if let delegate = delegate {
            segmentedControl.selectedSegmentIndex = delegate.lang
        }
        else{
            segmentedControl.selectedSegmentIndex = 0
        }
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var langLabel:UILabel = {
        let label = UILabel()
        label.text = "Язык"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBarIfPossible()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

    
}


extension SettingsViewController{
    
    func setupView() {
        view.backgroundColor = .systemYellow
        view.addSubview(modeLabel)
        view.addSubview(modeSwitch)
        view.addSubview(langLabel)
        view.addSubview(langSegmentedControl)
    }
    
    func setupNavigationBarIfPossible(){
        self.navigationItem.title = "Настройки"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        delegate?.changeLang(lang: sender.selectedSegmentIndex)
    }
    @objc func switchStateDidChange(_ sender:UISwitch!){
        delegate?.changePlayMode(mode: sender.isOn)
    }
}
