//
//  Pendulum.swift
//  PhysicsApp
//
//  Created by The Evanator on 9/10/22.
//

import UIKit

class Pendulum: UIView {

    var circleDiameter: CGFloat!
    var stringWidth: CGFloat!
    var color: UIColor!
    
    var r: CGFloat!
    var origin: CGPoint!
    var theta: CGFloat!
    var omega: CGFloat! = 0
    var alpha_: CGFloat = 0
    var g: CGFloat = 0.00001
    
    var timer: Timer!
    var previousTime: CGFloat = 0
    
    
    required init(frame: CGRect, length: CGFloat, circleDiameter: CGFloat, angle: CGFloat, speedMultiplier: CGFloat, color: UIColor, stringWidth: CGFloat) {
        super.init(frame: frame)
        self.backgroundColor = .clear

        self.r = length
        self.origin = CGPoint(x: frame.width/2, y: 5)
        self.theta = angle * CGFloat.pi / 180
        if speedMultiplier != 0 { self.g *= speedMultiplier }

        self.color = color
        self.circleDiameter = circleDiameter
        self.stringWidth = stringWidth

        start()
    }
    
    func start() {
        self.previousTime = Date().timeIntervalSince1970
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(run), userInfo: nil, repeats: true)
    }
    
    @objc func run() {
        let elapsedTime = Date().timeIntervalSince1970 - previousTime
        previousTime = Date().timeIntervalSince1970
        
        self.alpha_ = self.g * sin(theta) * r
        self.omega += alpha_
        
        theta -= omega
        
        setNeedsDisplay()
    }
    
    func pause() {
        self.timer.invalidate()
    }
    
    func unpause() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(run), userInfo: nil, repeats: true)
    }
    
    func setAngle(angle: CGFloat) {
        self.timer.invalidate()
        self.theta = angle * CGFloat.pi / 180
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let x = sin(theta) * r
        let y = cos(theta) * r
        let stringEnd = CGPoint(x: origin.x + x, y: origin.y + y)
        
        let string = UIBezierPath()
        string.move(to: origin)
        string.addLine(to: stringEnd)
        string.close()
        
        string.lineJoinStyle = .round
        color.set()
        string.lineWidth = stringWidth
        
        string.stroke()
        
        let circle = UIBezierPath(arcCenter: stringEnd, radius: self.circleDiameter/2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        color.set()
        circle.fill()
        circle.stroke()
    }
    
    
    
}
