//
//  ChargesLabVC.swift
//  PhysicsApp
//
//  Created by The Evanator on 2/23/23.
//

import UIKit

class ChargesLabVC: UIViewController {
    
    var charges: [Charge] = []
    
    var arrowView = ArrowView()
    var chargeView = ChargeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        view.backgroundColor = .black
        
        arrowView = ArrowView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width))
        view.addSubview(arrowView)
        
        chargeView = ChargeView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width))
        view.addSubview(chargeView)
        
        chargeView.addCharge(charge: 1, loc: chargeView.center, vc: self)
        
        updateArrowView()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom, .top]
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    func updateArrowView() {
        arrowView.updateArrows(charges: chargeView.charges)
    }


}

struct ElectricField {
    var magnitude: CGFloat
    var angle: CGFloat
}

class ArrowView: UIView {
    
    var arrows: [Arrow] = []
    let length = 30.0
    let spacing = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupArrows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupArrows() {
        for x in stride(from: length/2, to: self.frame.width - length/2, by: spacing) {
            for y in stride(from: length/2, to: self.frame.height - length/2, by: spacing) {
                let arrow = Arrow(frame: CGRect(x: 0, y: 0, width: length, height: length))
                arrow.center = CGPoint(x: x, y: y)
                self.addSubview(arrow)
                arrows.append(arrow)
            }
        }
    }
    
    func updateArrows(charges: [Charge]) {
        for arrow in arrows {
            var fields: [ElectricField] = []
            for charge in charges {
                let field = electricField(charge: charge.charge, chargeLoc: charge.center, arrowLoc: arrow.center)
                fields.append(field)
            }
            let totalElectricField = electricFieldSum(fields: fields)
            arrow.update(angle: totalElectricField.angle, opacity: arrowOpacity(magnitude: totalElectricField.magnitude))
            
        }
    }
    
    func electricField(charge: Int, chargeLoc: CGPoint, arrowLoc: CGPoint) -> ElectricField {
        let vector = distanceVector(chargeLoc, arrowLoc)
        let magnitude = abs(CGFloat(charge) / (vector.x * vector.x + vector.y * vector.y)) // q / r^2
        let angle = atan2(vector.y, vector.x)
        return ElectricField(magnitude: magnitude, angle: angle + (charge == 1 ? 0.0 : CGFloat.pi))
    }
    
    func electricFieldSum(fields: [ElectricField]) -> ElectricField {
        var totalEComponents = CGPoint.zero
        
        for field in fields {
            let components = fieldComponents(field: field)
            totalEComponents.x += components.x
            totalEComponents.y += components.y
        }
        
        let magnitude = sqrt(totalEComponents.x * totalEComponents.x + totalEComponents.y * totalEComponents.y)
        let angle = atan2(totalEComponents.y, totalEComponents.x)
        return ElectricField(magnitude: magnitude, angle: angle)
    }
    
    func arrowOpacity(magnitude: CGFloat) -> Float {
        let max: CGFloat = 0.0005
        let min: CGFloat = 0.0
        
        if magnitude > max { return 1 }
        else { return cbrt(Float((magnitude - min) / (max - min))) }
    }
    
    func distanceVector(_ chargeLoc: CGPoint, _ arrowLoc: CGPoint) -> CGPoint {
        return CGPoint(x: arrowLoc.x - chargeLoc.x, y: arrowLoc.y - chargeLoc.y)
    }
    
    func fieldComponents(field: ElectricField) -> CGPoint {
        let x = cos(field.angle) * field.magnitude
        let y = sin(field.angle) * field.magnitude
        return CGPoint(x: x, y: y)
    }
}

class Arrow: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let arrow = UIImageView()
        arrow.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        arrow.image = UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration(weight: .black))
        arrow.tintColor = .white
        arrow.contentMode = .scaleAspectFit
        self.addSubview(arrow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(angle: CGFloat, opacity: Float) {
        self.transform = CGAffineTransformMakeRotation(angle)
        self.layer.opacity = opacity
    }
}

class ChargeView: UIView {
    
    var charges: [Charge] = []
    let length = 30.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        let ui = UI(frame: self.bounds)
        self.addSubview(ui)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCharge(charge: Int, loc: CGPoint, vc: ChargesLabVC) {
        let charge = Charge(frame: CGRect(x: 0, y: 0, width: length, height: length), charge: charge, vc: vc)
        charge.center = loc
        self.addSubview(charge)
        charges.append(charge)
    }
    
    func removeAllCharges() {
        for charge in charges {
            charge.removeFromSuperview()
        }
        charges.removeAll()
        let vc = findViewController() as! ChargesLabVC
        vc.updateArrowView()
    }
}

class Charge: UIView {
    
    var initialCenter = CGPoint.zero
    var charge = 0
    
    var vc: ChargesLabVC!
    
    required init(frame: CGRect, charge: Int, vc: ChargesLabVC) {
        super.init(frame: frame)
        
        self.initialCenter = self.center
        self.charge = charge
        self.vc = vc
        
        let circle = UIView(frame: self.bounds)
        circle.layer.cornerRadius = frame.width/2
        circle.backgroundColor = charge == 1 ? .systemRed : .systemBlue
        self.addSubview(circle)
        
        let symbolView = UIImageView(frame: CGRect(x: frame.width * 0.1, y: frame.width * 0.1, width: frame.width * 0.8, height: frame.width * 0.8))
        symbolView.image = UIImage(systemName: charge == 1 ? "plus" : "minus")
        symbolView.tintColor = .white
        symbolView.contentMode = .scaleAspectFit
        circle.addSubview(symbolView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveCharge))
        gesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(gesture)
    }
    
    @objc func moveCharge(_ gesture: UIPanGestureRecognizer) {
        let piece = gesture.view!
        let translation = gesture.translation(in: self.superview)
        
        if gesture.state == .began {
            initialCenter = piece.center
        }
        else if gesture.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
        else {
            piece.center = initialCenter
        }
        vc.updateArrowView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UI: UIView {
    
    var header: UIView!
    
    var initialCenter: CGPoint!
    var initialCenter1: CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeader() {
        let window = UIApplication.shared.windows.first
        let topPadding = window!.safeAreaInsets.top
        let bottomPadding = window!.safeAreaInsets.bottom
        header = UIView(frame: CGRect(x: topPadding + 10, y: 20, width: self.frame.width - topPadding - bottomPadding - 20, height: 30))
        header.backgroundColor = .clear
        self.addSubview(header)
        
        exitButton.frame = CGRect(x: 0, y: 0, width: 75, height: 30)
        exitButton.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        header.addSubview(exitButton)
        
        resetButton.frame = CGRect(x: exitButton.frame.maxX + 10, y: 0, width: 95, height: 30)
        resetButton.addTarget(self, action: #selector(removeCharges), for: .touchUpInside)
        header.addSubview(resetButton)
        
        aboutButton.frame = CGRect(x: resetButton.frame.maxX + 10, y: 0, width: 75, height: 30)
        header.addSubview(aboutButton)
        
        let minimize = UIButton(frame: CGRect(x: header.frame.width - 30, y: 0, width: 30, height: 30))
        minimize.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
        minimize.tintColor = .black
        minimize.backgroundColor = .white.withAlphaComponent(0.8)
        minimize.layer.cornerRadius = 10
        header.addSubview(minimize)
        
        let electron = UIView(frame: CGRect(x: minimize.frame.minX - 40, y: 0, width: 30, height: 30))
        electron.backgroundColor = .white.withAlphaComponent(0.8)
        electron.layer.cornerRadius = 10
        header.addSubview(electron)
        
        let circle = UIView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        circle.layer.cornerRadius = 10
        circle.backgroundColor = .systemBlue
        
        let symbolView = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        symbolView.image = UIImage(systemName: "minus")
        symbolView.tintColor = .white
        symbolView.contentMode = .scaleAspectFit
        electron.addSubview(circle)
        electron.addSubview(symbolView)

        let proton = UIView(frame: CGRect(x: electron.frame.minX - 40, y: 0, width: 30, height: 30))
        proton.backgroundColor = .white.withAlphaComponent(0.8)
        proton.layer.cornerRadius = 10
        header.addSubview(proton)
        
        let circle1 = UIView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        circle1.layer.cornerRadius = 10
        circle1.backgroundColor = .systemRed
        
        let symbolView1 = UIImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        symbolView1.image = UIImage(systemName: "plus")
        symbolView1.tintColor = .white
        symbolView1.contentMode = .scaleAspectFit
        proton.addSubview(circle1)
        proton.addSubview(symbolView1)
        
        
        fakeElectron.frame = CGRect(x: 20, y: 20, width: 30, height: 30)
        fakeElectron.subviews[0].frame = CGRect(x: 3, y: 3, width: 24, height: 24)
        fakeElectron.isHidden = true
        self.addSubview(fakeElectron)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(addElectron))
        gesture.maximumNumberOfTouches = 1
        electron.addGestureRecognizer(gesture)
        
        fakeProton.frame = CGRect(x: 20, y: 20, width: 30, height: 30)
        fakeProton.subviews[0].frame = CGRect(x: 3, y: 3, width: 24, height: 24)
        fakeProton.isHidden = true
        self.addSubview(fakeProton)
        let gesture1 = UIPanGestureRecognizer(target: self, action: #selector(addProton))
        gesture1.maximumNumberOfTouches = 1
        proton.addGestureRecognizer(gesture1)
    }
    
    @objc func addProton(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            fakeProton.center = gesture.location(in: self.superview)
            initialCenter1 = fakeProton.center
            fakeProton.isHidden = false
        }
        else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superview)
            let newCenter = CGPoint(x: initialCenter1.x + translation.x, y: initialCenter1.y + translation.y)
            fakeProton.isHidden = true
            let vc = findViewController() as! ChargesLabVC
            (self.superview as! ChargeView).addCharge(charge: 1, loc: newCenter, vc: vc)
            vc.updateArrowView()
        }
        else if gesture.state == .cancelled {
            fakeProton.isHidden = true
        }
        else {
            let translation = gesture.translation(in: self.superview)
            let newCenter = CGPoint(x: initialCenter1.x + translation.x, y: initialCenter1.y + translation.y)
            fakeProton.center = newCenter
        }
    }
    
    @objc func addElectron(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            fakeElectron.center = gesture.location(in: self.superview)
            initialCenter = fakeElectron.center
            fakeElectron.isHidden = false
        }
        else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superview)
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            fakeElectron.isHidden = true
            let vc = findViewController() as! ChargesLabVC
            (self.superview as! ChargeView).addCharge(charge: -1, loc: newCenter, vc: vc)
            vc.updateArrowView()
        }
        else if gesture.state == .cancelled {
            fakeElectron.isHidden = true
        }
        else {
            let translation = gesture.translation(in: self.superview)
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            fakeElectron.center = newCenter
        }
    }
    
    @objc func removeCharges() {
        let chargesView = (self.superview as! ChargeView)
        chargesView.removeAllCharges()
    }
    
    @objc func handleExit() {
        let vc = findViewController() as! ChargesLabVC
        vc.dismiss(animated: true)
    }
    
    let fakeProton: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = 15
        circle.backgroundColor = .systemRed
        
        let symbolView = UIImageView()
        symbolView.image = UIImage(systemName: "plus")
        symbolView.tintColor = .white
        symbolView.contentMode = .scaleAspectFit
        circle.addSubview(symbolView)
        
        return circle
    }()
    
    let fakeElectron: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = 15
        circle.backgroundColor = .systemBlue
        
        let symbolView = UIImageView()
        symbolView.image = UIImage(systemName: "minus")
        symbolView.tintColor = .white
        symbolView.contentMode = .scaleAspectFit
        circle.addSubview(symbolView)
        
        return circle
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 10
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 10
        button.setTitle("Reset", for: .normal)
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .black
        return button
    }()
    
    let aboutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.setTitle("Info", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        return button
    }()
}
