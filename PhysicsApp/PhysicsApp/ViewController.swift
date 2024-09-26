//
//  ViewController.swift
//  PhysicsApp
//
//  Created by The Evanator on 9/10/22.
//

import UIKit

struct Topic {
    var title: String
    var simulationImage: UIImage
    var practiceImage: UIImage
    var color: UIColor
    var simulationName: String
    var simulationVC: UIViewController
}

struct Problem {
    var title: String
    var paragraph: String
    var visual: UIImage
    var units: String
    var hint: String
    var solution: UIImage
}

class ViewController: UIViewController {
    
    var pendulum: Pendulum!
    var appTitle: UILabel!
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    var topicMenu: TopicMenu!
    
    var topics: [Topic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let orientation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        view.backgroundColor = .white
        width = view.frame.width
        height = view.frame.height
        
        topics.append(Topic(title: "Kinematics", simulationImage: UIImage(named: "CannonLabLogo")!, practiceImage: UIImage(named: "paperpencil2")!, color: .systemRed, simulationName: "The City Cannon", simulationVC: KinematicsLabVC()))
        topics.append(Topic(title: "Electric Fields", simulationImage: UIImage(), practiceImage: UIImage(), color: .systemBlue, simulationName: "Point Charges", simulationVC: ChargesLabVC()))
        
        let pendulumFrame = CGRect(x: 0, y: 0, width: width * 0.4, height: width * 0.3)
        pendulum = Pendulum(frame: pendulumFrame, length: width * 0.3 * 0.75, circleDiameter: width * 0.3 * 0.3, angle: 40, speedMultiplier: 0, color: UIColor.black, stringWidth: width * 0.3 * 0.025)
        pendulum.center = view.center
        view.addSubview(pendulum)
        pendulum.backgroundColor = .clear
        let time = 0.95 * (96.3/(width * 0.3 * 0.75))
        let _ = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(animateLogo), userInfo: nil, repeats: false)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    @objc func animateLogo() {
        pendulum.pause()
        pendulum.setAngle(angle: -40)
        UIView.animate(withDuration: 0.75) {
            self.pendulum.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
            self.pendulum.frame.origin.x -= self.width * 0.17
        } completion: { _ in
            self.appTitle = UILabel()
            self.appTitle.text = "Pendulous"
            self.appTitle.textColor = .black
            self.appTitle.font = .systemFont(ofSize: self.width * 0.09, weight: .bold)
            self.appTitle.frame = CGRect(x: self.pendulum.frame.maxX - (self.pendulum.frame.width * 0.45), y: self.pendulum.frame.minY - self.pendulum.frame.height * 0.1, width: self.width * 0.5, height: self.pendulum.frame.height)
            self.appTitle.backgroundColor = .clear
            self.appTitle.alpha = 0
            self.view.addSubview(self.appTitle)
            UIView.animate(withDuration: 0.3) {
                self.appTitle.alpha = 1
            } completion: { _ in
                let displacement = self.appTitle.frame.minY - 50
                UIView.animate(withDuration: 1) {
                    self.pendulum.frame.origin.y -= displacement
                    self.appTitle.frame.origin.y -= displacement
                } completion: { _ in
                    let seperator = UIView(frame: CGRect(x: self.view.frame.width * 0.1, y: self.pendulum.frame.maxY + 5, width: self.view.frame.width * 0.8, height: 1))
                    seperator.backgroundColor = .secondaryLabel
                    self.view.addSubview(seperator)
                    
                    let sectionTitle = UILabel(frame: CGRect(x: self.view.frame.width * 0.1, y: self.pendulum.frame.maxY + 10, width: self.view.frame.width * 0.8, height: 50))
                    sectionTitle.textColor = .black
                    sectionTitle.textAlignment = .center
                    sectionTitle.font = .systemFont(ofSize: 25, weight: .black)
                    sectionTitle.text = "Into Simulations"
                    sectionTitle.adjustsFontSizeToFitWidth = true
                    self.view.addSubview(sectionTitle)
                    
                    let height = self.view.frame.height - (self.pendulum.frame.maxY + 10) - 50 - 50
                    self.topicMenu = TopicMenu(frame: CGRect(x: 0, y: self.pendulum.frame.maxY + 10 + 50, width: self.view.frame.width, height: height), topics: self.topics)
                    self.topicMenu.alpha = 0
                    self.view.addSubview(self.topicMenu)
                    UIView.animate(withDuration: 0.3) {
                        self.topicMenu.alpha = 1
                    } completion: { [self] _ in
                        let copyRight = UILabel(frame: CGRect(x: 20, y: topicMenu.frame.maxY, width: view.frame.width - 40, height: 30))
                        copyRight.text = "Copyright © 2024, Evan Cedeno. All Rights Reserved"
                        copyRight.textColor = .black
                        copyRight.textAlignment = .center
                        copyRight.font = .systemFont(ofSize: 10)
                        view.addSubview(copyRight)
                    }

                }

            }

        }

    }


}

