//
//  KinematicsLabVC.swift
//  PhysicsApp
//
//  Created by The Evanator on 9/12/22.
//

import UIKit

class KinematicsLabVC: UIViewController {
        
    var unitsPerMeter = 20.0
    
    let ground = UIImageView()
    
    let ballView = UIView()
    var ballScale = 1.00
    
    let cannonView = UIView()
    
    var ball = Ball(frame: CGRect.zero, color: UIColor.clear)
    
    var isRunning = false
    
    let menu = UIView()
    let stats = UIView()
    
    var header = UIView()
    
    var gravityLabel = UILabel()
    var gravityAmount = UILabel()
    var gravityBar = UISlider()
    
    var launchVelocity = UILabel()
    var velocityLabel = UILabel()
    var launchBar = UISlider()
    
    var projectilePath = UIBezierPath()
//    var pathTimer = Timer()
    var shapeLayer = CAShapeLayer()
    var cannonBody = UIImageView()
    
    var launchTimer = Timer()
    
    let heightLabel = UILabel()
    let distanceLabel = UILabel()
    var maxHeightLabel = UILabel()
    var timeLabel = UILabel()
    
    var launchDegree = UILabel()
    var launchAngle = UILabel()
    var angleBar = UISlider()
    
    var initialTouchLoc = CGPoint.zero
    var possibleNewAngle = 0.0
    var angleLabel = UILabel()
    let preLaunchVisual = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 181/255, blue: 226/255, alpha: 1)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width))
        background.image = UIImage(named: "cityBackground4")
        view.addSubview(background)
        
        let window = UIApplication.shared.windows.first
        let topPadding = window!.safeAreaInsets.top
        
        setupGround()
        
        let minSize = ball.calculateMaxDisplacements(vmax: 30, gMin: 10)
        ballView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        ballView.frame = CGRect(x: topPadding + 30, y: view.frame.width - 80 + 15 - (minSize.height + 50), width: minSize.width + 50, height: minSize.height + 50)
        view.addSubview(ballView)
        
        setupHeader()
        
        setupMenu()
        
        ball = Ball(frame: CGRect(x: -10, y: ballView.frame.height - 10, width: 20, height: 20), color: .black)
        ballView.addSubview(ball)
        
        cannonView.frame = CGRect(x: 0, y: 0, width: 1275/8.5, height: 1068/8.5)
        cannonView.center = ball.center
        cannonView.backgroundColor = .clear
//        cannonView.alpha = 0.95
        ballView.addSubview(cannonView)

        cannonBody = UIImageView(frame: cannonView.bounds)
        cannonBody.image = UIImage(named: "CannonBody5")
        cannonView.addSubview(cannonBody)
        cannonBody.transform = CGAffineTransform(rotationAngle: -45 * CGFloat.pi / 180)

        let wagonBody = UIImageView(frame: cannonView.bounds)
        wagonBody.image = UIImage(named: "Wagon4")
        cannonView.addSubview(wagonBody)
        
//        updatePreLaunchVisual(angle: 45)
//        preLaunchVisual.strokeColor = UIColor.orange.cgColor
//        preLaunchVisual.fillColor = UIColor.clear.cgColor
//        preLaunchVisual.lineWidth = 2
//        preLaunchVisual.lineCap = .round
//        view.layer.addSublayer(preLaunchVisual)
//
//        angleLabel.frame.size = CGSize(width: 50, height: 20)
//        let cannonCenter = cannonBody.convert(cannonBody.center, to: view.self)
//        angleLabel.frame.origin = CGPoint(x: cannonCenter.x + 50, y: cannonCenter.y - 20)
//        angleLabel.backgroundColor = .clear//.white.withAlphaComponent(0.8)
//        angleLabel.layer.cornerRadius = 10
//        angleLabel.clipsToBounds = true
//        angleLabel.textAlignment = .right
//        angleLabel.textColor = .systemYellow
//        angleLabel.text = "45º"
//        angleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .bold)
//        view.addSubview(angleLabel)
        
        let cannonGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCannonAngle))
        view.addGestureRecognizer(cannonGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return true
//    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
    //MARK: setup Ground
    func setupGround() {
        ground.frame = CGRect(x: 0, y: view.frame.width - 80, width: view.frame.height, height: 80)
//        ground.backgroundColor = .systemGreen
        ground.image = UIImage(named: "sidewalk3")
        view.addSubview(ground)
        
        let floor = UIImageView(frame: CGRect(x: 0, y: 0, width: ground.frame.width, height: 30))
//        floor.backgroundColor = UIColor(red: 196/255, green: 180/255, blue: 84/255, alpha: 1)
        floor.image = UIImage(named: "road6")
        ground.addSubview(floor)
        
//        launchButton.frame = CGRect(x: ground.frame.midX - 25, y: ground.frame.midY - 25, width: 50, height: 50)
        launchButton.frame = CGRect(x: ground.frame.midX - 45, y: ground.frame.minY + 30 + 5, width: 90, height: 34)
        launchButton.addTarget(self, action: #selector(launchButtonPressed), for: .touchUpInside)
        view.addSubview(launchButton)
        
        let window = UIApplication.shared.windows.first
        let bottomPadding = window!.safeAreaInsets.bottom
        
        heightLabel.frame = CGRect(x: view.frame.height - bottomPadding - 150, y: 30, width: 150, height: 25)
        heightLabel.text = "Height: 0m"
        heightLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        heightLabel.adjustsFontSizeToFitWidth = true
        heightLabel.textAlignment = .left
        heightLabel.textColor = .black
        ground.addSubview(heightLabel)
        
        distanceLabel.frame = CGRect(x: view.frame.height - bottomPadding - 150, y: heightLabel.frame.maxY, width: 150, height: 25)
        distanceLabel.text = "Range: 0m"
        distanceLabel.font = .monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        distanceLabel.textAlignment = .left
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.textColor = .black
        ground.addSubview(distanceLabel)
    }
    
    //MARK: Setup Header
    func setupHeader() {
        let window = UIApplication.shared.windows.first
        let topPadding = window!.safeAreaInsets.top
        let bottomPadding = window!.safeAreaInsets.bottom
        header = UIView(frame: CGRect(x: topPadding + 10, y: 20, width: view.frame.height - topPadding - bottomPadding, height: 30))
        header.backgroundColor = .clear
        view.addSubview(header)
        
        exitButton.frame = CGRect(x: 0, y: 0, width: 75, height: 30)
        exitButton.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        header.addSubview(exitButton)
        
        resetButton.frame = CGRect(x: exitButton.frame.maxX + 10, y: 0, width: 95, height: 30)
        header.addSubview(resetButton)
        
        aboutButton.frame = CGRect(x: resetButton.frame.maxX + 10, y: 0, width: 75, height: 30)
        header.addSubview(aboutButton)
        
        zoomInButton.frame = CGRect(x: aboutButton.frame.maxX + 20, y: 0, width: 30, height: 30)
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        header.addSubview(zoomInButton)
        
        zoomOutButton.frame = CGRect(x: zoomInButton.frame.maxX + 5, y: 0, width: 30, height: 30)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        header.addSubview(zoomOutButton)
    }
    
    @objc func zoomIn() {
        ballScale += 0.25
        if ballScale >= 1.25 {
            ballScale = 1.25
            zoomInButton.backgroundColor = .lightGray.withAlphaComponent(0.5)
        }
        zoomOutButton.backgroundColor = .white.withAlphaComponent(0.8)
        
        let centerPoint = CGPoint(x: ballView.frame.minX, y: ballView.frame.maxY)
        UIView.animate(withDuration: 0.5) {
            self.ballView.transform = CGAffineTransform(scaleX: self.ballScale, y: self.ballScale)
            self.ballView.layer.position = centerPoint
        }
    }
    
    @objc func zoomOut() {
        ballScale -= 0.25
        if ballScale <= 0.25 {
            ballScale = 0.25
            zoomOutButton.backgroundColor = .lightGray.withAlphaComponent(0.5)
        }
        zoomInButton.backgroundColor = .white.withAlphaComponent(0.8)
        
        let centerPoint = CGPoint(x: ballView.frame.minX, y: ballView.frame.maxY)
        UIView.animate(withDuration: 0.5) {
            self.ballView.transform = CGAffineTransform(scaleX: self.ballScale, y: self.ballScale)
            self.ballView.layer.position = centerPoint
        }
    }
    
    
    // MARK: Setup Menu
    func setupMenu() {
        let menuHeight: CGFloat = 110
        let menuWidth: CGFloat = 210.0
        menu.frame = CGRect(x: view.frame.height - menuWidth - 20, y: 20, width: menuWidth, height: menuHeight)
        menu.backgroundColor = .white.withAlphaComponent(0.8)
        menu.layer.cornerRadius = 20
        view.addSubview(menu)
        
        launchAngle = UILabel(frame: CGRect(x: 10, y: 10, width: menuWidth - 20, height: (menuHeight - 35) / 3))
        launchAngle.text = "Launch Angle"
        launchAngle.font = .boldSystemFont(ofSize: 20)
        launchAngle.adjustsFontSizeToFitWidth = true
        launchAngle.textColor = .black
        menu.addSubview(launchAngle)
        
        angleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: menuWidth - 20, height: (menuHeight - 35) / 3))
        angleLabel.textAlignment = .right
        angleLabel.font = .systemFont(ofSize: 15)
        angleLabel.adjustsFontSizeToFitWidth = true
        angleLabel.textColor = .black
        angleLabel.text = "45º"
        menu.addSubview(angleLabel)

        launchVelocity = UILabel(frame: CGRect(x: 10, y: launchAngle.frame.maxY + 10, width: menuWidth - 20, height: (menuHeight - 35) / 3))
        launchVelocity.text = "Launch Speed"
        launchVelocity.font = .boldSystemFont(ofSize: 20)
        launchVelocity.adjustsFontSizeToFitWidth = true
        launchVelocity.textColor = .black
        menu.addSubview(launchVelocity)
        
        velocityLabel = UILabel(frame: CGRect(x: 10, y: launchAngle.frame.maxY + 10, width: menuWidth - 20, height: (menuHeight - 35) / 3))
        velocityLabel.textAlignment = .right
        velocityLabel.font = .systemFont(ofSize: 15)
        velocityLabel.adjustsFontSizeToFitWidth = true
        velocityLabel.textColor = .black
        velocityLabel.text = "15m/s"
        menu.addSubview(velocityLabel)
        
        launchBar = UISlider(frame: CGRect(x: 10, y: launchVelocity.frame.maxY + 5, width: menuWidth - 20, height: (menuHeight - 35) / 3))
        launchBar.minimumValue = 0
        launchBar.maximumValue = 30
        launchBar.value = 15
        launchBar.maximumTrackTintColor = .systemBlue
        launchBar.tintColor = .systemBlue
        launchBar.addTarget(self, action: #selector(adjustVelocity(_:)), for: .valueChanged)
        menu.addSubview(launchBar)
    }
    
    //MARK: Slider Functions
    
    @objc func adjustVelocity(_ slider: UISlider) {
        if isRunning == true { slider.value = Float(ball.vi / unitsPerMeter) }
        else { slider.value = roundf(slider.value) }
        
        velocityLabel.text = "\(Int(slider.value))m/s"
    }
    
//    @objc func adjustAngle(_ slider: UISlider) {
//        if isRunning == true { slider.value = round(Float(ball.theta * 180 / Double.pi)) }
//        else { slider.value = round((slider.value - 15) / 15) * 15 + 15 }
//
//        launchDegree.text = "\(Int(slider.value))°"
//        cannonBody.transform = CGAffineTransform(rotationAngle: -1 * CGFloat(slider.value) * CGFloat.pi / 180)
//    }
    
    @objc func handleCannonAngle(_ sender: UIPanGestureRecognizer) {
        if ball.isGrounded() != true || isRunning == true { return }
        if sender.state == .began {
            initialTouchLoc = sender.location(ofTouch: 0, in: view)
        }
        if sender.state == .changed {
            let loc = sender.location(ofTouch: 0, in: view)
            let distance = loc.y - initialTouchLoc.y
            let steps = round(distance / 15)
            let currentAngle = round(ball.theta * 180 / Double.pi)
            possibleNewAngle = currentAngle - 5 * steps
            if possibleNewAngle > 90 { possibleNewAngle = 90 }
            if possibleNewAngle < 10 { possibleNewAngle = 10 }
            cannonBody.transform = CGAffineTransform(rotationAngle: -possibleNewAngle * CGFloat.pi / 180)
            angleLabel.text = "\(Int(possibleNewAngle))º"
//            updatePreLaunchVisual(angle: possibleNewAngle)
        }
        if sender.state == .ended {
            cannonBody.transform = CGAffineTransform(rotationAngle: -possibleNewAngle * CGFloat.pi / 180)
            ball.theta = possibleNewAngle * Double.pi / 180
            angleLabel.text = "\(Int(possibleNewAngle))º"
//            updatePreLaunchVisual(angle: possibleNewAngle)
        }
        if sender.state == .cancelled {
            cannonBody.transform = CGAffineTransform(rotationAngle: -ball.theta)
            angleLabel.text = "\(Int(ball.theta))º"
//            updatePreLaunchVisual(angle: ball.theta)
        }
    }
    
    func updatePreLaunchVisual(angle: Double) {
        let theta = angle * Double.pi / 180
        let cannonCenter = cannonBody.convert(cannonBody.center, to: view.self)
        let preLaunchVisualPath = UIBezierPath()
        preLaunchVisualPath.move(to: cannonCenter)
        preLaunchVisualPath.addLine(to: CGPoint(x: cannonCenter.x + 100, y: cannonCenter.y))
//        preLaunchVisualPath.move(to: cannonCenter)
//        preLaunchVisualPath.addLine(to: CGPoint(x: cannonCenter.x, y: cannonCenter.y - 100))
        preLaunchVisualPath.move(to: cannonCenter)
        preLaunchVisualPath.addLine(to: CGPoint(x: cannonCenter.x + cos(theta) * 100, y: cannonCenter.y - sin(theta) * 100))
        preLaunchVisualPath.move(to: cannonCenter)
        preLaunchVisualPath.addArc(withCenter: cannonCenter, radius: 50, startAngle: 0, endAngle: -theta, clockwise: false)
        preLaunchVisual.path = preLaunchVisualPath.cgPath
        
        angleLabel.text = "\(Int(angle))º"
    }
    
    // MARK: Launch Button Pressed
    
    @objc func launchButtonPressed() {
        if isRunning == false {
            isRunning = true
            menu.isUserInteractionEnabled = false
            menu.isHidden = true
//            let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
//            launchButton.setImage(image, for: .normal)
            if ball.isGrounded() {
                ball.frame.origin = ball.origin
                cannonBody.transform = CGAffineTransform(rotationAngle: -ball.theta)
                ball.setupLaunch(velocity: Double(launchBar.value), angle: ball.theta * 180 / Double.pi, gravity: ball.g)
//                ball.g = Double(gravityBar.value)
                animateProjectilePath()
                ball.hit()
                launchButton.setTitle("0.0s", for: .normal)
            }
            else {
                ball.resume()
                resumePathAnimation()
            }
            launchTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLaunchValues), userInfo: nil, repeats: true)
            distanceLabel.text = ""
            heightLabel.text = ""
        }
        else if isRunning == true {
            isRunning = false
//            let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
//            launchButton.setImage(image, for: .normal)
            launchTimer.invalidate()
            if ball.isGrounded() {
                launchButton.setTitle("\(String(format: "%.2f", round(ball.calculateAirTime() * 100) / 100))s", for: .normal)
                menu.isUserInteractionEnabled = true
                menu.isHidden = false
                setPostLaunchData()
                handlePathSublayers()
                UIView.animate(withDuration: 0.5) {
                    self.launchButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                } completion: { _ in
                    UIView.animate(withDuration: 0.5) {
                        self.launchButton.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
                    } completion: { _ in
                        self.launchButton.setTitle("LAUNCH", for: .normal)
                    }
                }
            }
            else {
                pausePathAnimation()
                ball.pause()
                launchButton.setTitle("\(String(format: "%.2f", round(ball.t * 100) / 100))s", for: .normal)
                setExactDisplacements()
            }
        }
    }
    
    // MARK: Last Functions
    
//    @objc func updatePath() {
//        projectilePath.addLine(to: ball.center)
//        projectilePath.move(to: ball.center)
//        projectilePath.close()
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = projectilePath.cgPath
//        shapeLayer.strokeColor = UIColor.black.cgColor
//        shapeLayer.lineWidth = 2.0
//        ballView.layer.addSublayer(shapeLayer)
//    }
    
    @objc func updateLaunchValues() {
        launchButton.setTitle("\(round(ball.t * 10) / 10)s", for: .normal)
    }
    
    @objc func setExactDisplacements() {
        let displacements = ball.calculateDisplacement(time: round(ball.t * 100) / 100)
        distanceLabel.text = "Range: \(String(format: "%.2f", round(displacements.width * 100) / 100))m"
        heightLabel.text = "Height: \(String(format: "%.2f", round(displacements.height * 100) / 100))m"
    }
    
    @objc func setPostLaunchData() {
        let displacements = ball.calculateDisplacement(time: ball.calculateAirTime()/2)
        distanceLabel.text = "Range: \(String(format: "%.2f", round(displacements.width * 2 * 100) / 100))m"
        heightLabel.text = "Max Height: \(String(format: "%.2f", round(displacements.height * 100) / 100))m"
    }
    
    func handlePathSublayers() {
        var count = ballView.layer.sublayers!.count
        if count <= 3 { return }
        if count == 7 {
            ballView.layer.sublayers?.remove(at: 4)
            count -= 1
        }
        if count == 4 {
            (ballView.layer.sublayers![1] as! CAShapeLayer).strokeColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        }
        else if count == 5 {
            (ballView.layer.sublayers![1] as! CAShapeLayer).strokeColor = UIColor.blue.withAlphaComponent(0.5).cgColor
            (ballView.layer.sublayers![2] as! CAShapeLayer).strokeColor = UIColor.blue.withAlphaComponent(0.25).cgColor
        }
        else if count == 6 {
            (ballView.layer.sublayers![1] as! CAShapeLayer).strokeColor = UIColor.blue.withAlphaComponent(0.5).cgColor
            (ballView.layer.sublayers![2] as! CAShapeLayer).strokeColor = UIColor.blue.withAlphaComponent(0.25).cgColor
            (ballView.layer.sublayers![3] as! CAShapeLayer).strokeColor = UIColor.blue.withAlphaComponent(0.1).cgColor
        }
    }
    
    func animateProjectilePath() {
        let curve = UIBezierPath()
        curve.move(to: CGPoint(x: ball.center.x, y: ball.center.y))
        let control = ball.calculateControlPoint()
        let xAdd = ball.theta != Double.pi / 2 ? 0.0 : 1.0
        let xCoor = (control.x * 2) - (ball.frame.width / 2) - ball.origin.x
        curve.addQuadCurve(to: CGPoint(x: xCoor + xAdd, y: ball.center.y), controlPoint: control)
        shapeLayer = CAShapeLayer()
        shapeLayer.path = curve.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineCap = .round
        ballView.layer.insertSublayer(shapeLayer, at: 0)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = ball.calculateAirTime() * 1.05
        shapeLayer.add(animation, forKey: "drawKeyAnimation")
    }
    
    func pausePathAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0
        shapeLayer.timeOffset = pausedTime
    }

    func resumePathAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0
        shapeLayer.beginTime = 0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    @objc func handleExit() {
        dismiss(animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    let launchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
//        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
//        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("LAUNCH", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.titleLabel?.font = .monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
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
    
    let zoomInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let zoomOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
}
//MARK: Ball Class

class Ball: UIView {
    
    var unitsPerMeter = 20.0
    
    var timer: Timer!
    var g: Double = 10
    
    var origin: CGPoint = CGPoint.zero
    var groundY: CGFloat = 0
    
    var vi: Double = 0
    var theta: Double = 45 * Double.pi / 180
    
    var startTime: Double = 0
    var t: Double = 0
    var pauseTime = 0.0
    
    var gravity = 0.0
    var initialV = 0.0
    
    var displacementX = 0.0
    var displacementY = 0.0
    
//    var damping: Double = 0.5
    
    required init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = color
        self.layer.cornerRadius = frame.width/2
        
        self.origin = frame.origin
        self.groundY = frame.maxY
        
        let layer = CAShapeLayer()
        self.superview?.layer.addSublayer(layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLaunch(velocity: Double, angle: Double, gravity: Double) {
        self.vi = velocity
        self.theta = angle * Double.pi / 180
        self.g = gravity
        self.gravity = self.g * unitsPerMeter
        self.initialV = self.vi * unitsPerMeter
    }
    
    func hit() {
        self.startTime = Date().timeIntervalSince1970
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updatePosition), userInfo: nil, repeats: true)
    }
    
    func pause() {
        timer.invalidate()
        pauseTime = Date().timeIntervalSince1970
    }
    
    func resume() {
        startTime += Date().timeIntervalSince1970 - pauseTime
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updatePosition), userInfo: nil, repeats: true)
    }
    
//    func updateUnitsPerMeter(previous: Double) {
//        self.frame.size = CGSize(width: 1.2 * unitsPerMeter, height: 1.2 * unitsPerMeter)
//        self.layer.cornerRadius = (unitsPerMeter * 1.2) / 2
//        origin.y = groundY - (1.2 * unitsPerMeter)
//        self.frame.origin.y = origin.y
//        self.gravity = self.g * unitsPerMeter
//        self.initialV = self.vi * unitsPerMeter
//        print(gravity)
//        if previous != 1 {
//            let distance = frame.origin.x - origin.x
//            if distance == 0 { return }
//            frame.origin.x = unitsPerMeter / (previous / distance)
//        }
//    }
    
    @objc func updatePosition() {
        self.t = Date().timeIntervalSince1970 - startTime
        var dx = (cos(self.theta) * initialV) * self.t //; displacementX = dx
        let dy = (sin(self.theta) * initialV) * self.t + (0.5 * gravity * -1 * self.t * self.t) //; displacementY = dy
        if dx < 0 {dx = 0}
        
        self.frame.origin.x = self.origin.x + dx
        self.frame.origin.y = self.origin.y - dy
        
        if self.frame.origin.y >= self.groundY - self.frame.width {
            hitGround()
        }
    }
    
    func isGrounded() -> Bool {
        return (self.frame.maxY == groundY)
    }
    
    func hitGround() {
        timer.invalidate()
        self.frame.origin.y = groundY - self.frame.width
        self.frame.origin.x = origin.x + (cos(self.theta) * initialV) * calculateAirTime()
        guard let vc = findViewController() as? KinematicsLabVC else { return }
        vc.launchButtonPressed()
    }
    
    func cancelLaunch() {
        timer.invalidate()
        self.frame.origin = origin
        guard let vc = findViewController() as? KinematicsLabVC else { return }
        vc.launchButtonPressed()
    }
    
    func calculateMaxDisplacements(vmax: CGFloat, gMin: CGFloat) -> CGSize {
        let dx = (vmax * vmax * 1) / gMin
        let dy = vmax / (2 * gMin)
        return CGSize(width: dx, height: dy)
    }
    
    func calculateControlPoint() -> CGPoint {
        let ballLength = self.frame.width
        let dx = self.vi * self.vi * sin(2 * self.theta) / self.g
        let height = tan(self.theta) * (dx / 2)
        return CGPoint(x: origin.x + (ballLength / 2) + (dx * unitsPerMeter / 2), y: origin.y + (ballLength / 2) - (height * unitsPerMeter))
    }
    
    func calculateAirTime() -> Double {
        return 2 * self.vi * sin(self.theta) / self.g
    }
    
    func calculateDisplacement(time: Double) -> CGSize {
        let displacementX = (cos(self.theta) * self.vi) * time
        let displacementY = (sin(self.theta) * self.vi) * time + (0.5 * self.g * -1 * time * time)
        return CGSize(width: displacementX, height: displacementY)
    }
    
//    // animation stuff
//    var dx: CGFloat!
//    var maxHeight: CGFloat!
//
//    func menuAnimation(dx: CGFloat, maxHeight: CGFloat) {
//        self.dx = dx; self.maxHeight = maxHeight
//
//        let viy = sqrt(2 * g * maxHeight)
//        let time = viy / g * 2
//        let vix = dx / time
//
//        let angle = atan(viy/vix) * 180 / CGFloat.pi
//        let velocity = sqrt((vix * vix) + (viy * viy))
//
//        hit(velocity: velocity, angle: angle)
//        let _ = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(resetAnimation), userInfo: nil, repeats: false)
//
//    }
//
//    @objc func resetAnimation() {
//        timer.invalidate()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.frame.origin = self.origin
//            self.menuAnimation(dx: self.dx, maxHeight: self.maxHeight)
//        }
//    }
    
}
