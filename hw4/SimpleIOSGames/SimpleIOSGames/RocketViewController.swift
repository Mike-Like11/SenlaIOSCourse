//
//  RocketViewController.swift
//  SimpleIOSGames
//
//  Created by Mike I on 24.04.2022.
//

import UIKit

final class RocketViewController: UIViewController {
    
    private lazy var rocketButton: UIButton = {
        let button = UIButton()
        button.setTitle("Стартуем!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addAction(UIAction() { [weak self] _ in
            self?.startAnimation()
        }, for: .touchUpInside)
        return button
    }()
    
    private let rocketLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.black.cgColor
        return shape
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let path = UIBezierPath()
        let x = view.bounds.width/2
        let y = view.bounds.height/2
        path.move(to: CGPoint(x: Int(0.75*x), y: Int(y)+160))
        path.addQuadCurve(to: CGPoint(x: Int(0.80*x), y: Int(y)+100),
                          controlPoint: CGPoint(x: Int(0.65*x), y: Int(y)+120))
        path.addCurve(to: CGPoint(x: x, y: y),
                      controlPoint1: CGPoint(x: Int(0.8*x), y: Int(y)+40),
                      controlPoint2: CGPoint(x: Int(0.95*x), y: Int(y)+10))
        path.addCurve(to: CGPoint(x: Int(1.20*x), y: Int(y)+100),
                      controlPoint1: CGPoint(x: Int(1.05*x), y: Int(y)+10),
                      controlPoint2: CGPoint(x: Int(1.2*x), y: Int(y)+40))
        path.addQuadCurve(to: CGPoint(x: Int(1.25*x), y: Int(y)+160),
                          controlPoint: CGPoint(x: Int(1.35*x), y: Int(y)+120))
        path.addLine(to: CGPoint(x: Int(1.10*x), y: Int(y)+130))
        path.addLine(to: CGPoint(x: Int(0.9*x), y: Int(y)+130))
        path.addLine(to: CGPoint(x: Int(0.75*x), y: Int(y)+160))
        path.close()
        rocketLayer.path = path.cgPath
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rocketLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
}


private extension RocketViewController{
    func setupView() {
        view.backgroundColor = .systemYellow
        view.addSubview(rocketButton)
        view.layer.addSublayer(rocketLayer)
    }
    func setupConstraints(){
        rocketButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rocketButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            rocketButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            rocketButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rocketButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    func startAnimation(){
        rocketButton.isHidden = true
        UIView.animate(withDuration: 5.0,  animations: {
            self.rocketButton.alpha = 0
        }) { (finished) in
            self.rocketButton.isHidden = false
            self.rocketButton.alpha = 1
        }
        animationOfShaking()
        animationOfBlastOff()
        animationOfScalingPerspective()
    }
    func animationOfShaking() {
        let  shakeRocket = CABasicAnimation(keyPath: "position.x")
        shakeRocket.fromValue = view.bounds.width/2+5
        shakeRocket.toValue = view.bounds.width/2-5
        shakeRocket.duration = 0.05
        shakeRocket.beginTime = CACurrentMediaTime()
        shakeRocket.repeatCount = 10
        shakeRocket.autoreverses = true
        rocketLayer.add(shakeRocket, forKey: nil)
    }
    
    func animationOfBlastOff() {
        let goRocket = CABasicAnimation(keyPath: "position.y")
        goRocket.fromValue = view.bounds.height/2
        goRocket.toValue = 0
        goRocket.duration = 4.0
        goRocket.beginTime = CACurrentMediaTime()+1.0
        rocketLayer.add(goRocket, forKey: nil)
    }
    
    func animationOfScalingPerspective() {
        let sizeRocket = CABasicAnimation(keyPath: "transform.scale")
        sizeRocket.fromValue = 1
        sizeRocket.toValue = 0.1
        sizeRocket.duration = 3.0
        sizeRocket.beginTime = CACurrentMediaTime() + 2.0
        rocketLayer.add(sizeRocket, forKey: nil)
    }
}
