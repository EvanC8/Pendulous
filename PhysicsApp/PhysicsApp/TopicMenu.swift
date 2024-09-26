//
//  Topics.swift
//  PhysicsApp
//
//  Created by The Evanator on 9/10/22.
//

import UIKit
import CloudKit

class TopicMenu: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    
    var cell1: TopicCell!
    var cell2: TopicCell!
    
    var topics: [Topic]!
    
    required init(frame: CGRect, topics: [Topic]) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.topics = topics
        self.layer.masksToBounds = false
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + 100)
        self.addSubview(scrollView)
        
        let width = scrollView.frame.width
        
        cell1 = TopicCell(frame: CGRect(x: width * 0.075, y: 10, width: width * 0.85, height: width * 0.85 * 0.65), topic: topics[0])
        scrollView.addSubview(cell1)
        
        cell2 = TopicCell(frame: CGRect(x: width * 0.075, y: cell1.frame.maxY + 20, width: width * 0.85, height: width * 0.85 * 0.65), topic: topics[1])
        scrollView.addSubview(cell2)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
}

class TopicCell: UIView {
    
    var topic: Topic!
    
    required init(frame: CGRect, topic: Topic) {
        super.init(frame: frame)
        self.backgroundColor = topic.color
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
        shadowLayer.fillColor = topic.color.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 4
        layer.insertSublayer(shadowLayer, at: 0)
        
        self.topic = topic
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        self.addSubview(title)
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textColor = .white
        title.textAlignment = .center
        title.text = topic.title
        
        let background = UIImageView(frame: CGRect(x: 0, y: 50, width: frame.width, height: frame.height - 50))
        background.image = topic.simulationImage
        background.contentMode = .scaleAspectFit
        self.addSubview(background)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
        gesture.numberOfTapsRequired = 0
        gesture.numberOfTouchesRequired = 1
        gesture.minimumPressDuration = 0
        gesture.allowableMovement = 0
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pressed(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4) {
                self.transform = CGAffineTransform(scaleX: 1.015, y: 1.015)
            }
        }
        if gesture.state == .ended {
            let endLoc = gesture.location(ofTouch: 0, in: self)
            if self.bounds.contains(endLoc) == false {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                return
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                let vc = self.findViewController() as! ViewController
                let presentation = TopicPresentation(frame: vc.view.bounds, topic: self.topic)
                vc.view.addSubview(presentation)
            }
        }
        if gesture.state == .cancelled {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}

class TopicPresentation: UIView {
    
    var topic: Topic!
    var presentation: UIView!
    
    var section1: UIView!
    var description1: UILabel!
    
    var section2: UIView!
    var description2: UILabel!
    
    required init(frame: CGRect, topic: Topic) {
        super.init(frame: frame)
        self.topic = topic
        self.backgroundColor = .clear
        
        let background = UIButton(frame: self.bounds)
        background.backgroundColor = .black.withAlphaComponent(0.1)
        background.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        self.addSubview(background)
        
        presentation = UIView(frame: CGRect(x: 0, y: 0, width: frame.width * 0.9, height: frame.height * 0.8))
        presentation.center = self.center
        presentation.backgroundColor = topic.color
        presentation.layer.cornerRadius = 20
        self.addSubview(presentation)
        
        setupHeader()
        
        setupSimulationSection()
        
        setupPracticeSection()
    }
    
    func setupHeader() {
        let title = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 50))
        title.text = topic.title
        title.textAlignment = .left
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 30)
        presentation.addSubview(title)
        
        let exitButton = UIButton(frame: CGRect(x: presentation.frame.width - 10 - 50, y: 10, width: 50, height: 50))
        exitButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        exitButton.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        exitButton.tintColor = .white
        presentation.addSubview(exitButton)
    }
    
    func setupSimulationSection() {
        section1 = UIView(frame: CGRect(x: 10, y: 100, width: presentation.frame.width - 20, height: 100))
        section1.backgroundColor = .clear
        presentation.addSubview(section1)
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: section1.frame.height, height: section1.frame.height))
        image.image = topic.simulationImage
        image.contentMode = .scaleAspectFit
        section1.addSubview(image)
        
        let heading = UILabel(frame: CGRect(x: image.frame.maxX + 10, y: 0, width: section1.frame.width - image.frame.width - 10, height: 30))
        heading.text = "Explore the Topic"
        heading.textColor = .white
        heading.textAlignment = .left
        heading.adjustsFontSizeToFitWidth = true
        heading.font = .systemFont(ofSize: 20, weight: .medium)
        section1.addSubview(heading)
        
        let subHeading = UILabel(frame: CGRect(x: heading.frame.minX, y: heading.frame.maxY, width: heading.frame.width, height: 30))
        subHeading.text = topic.simulationName
        subHeading.textColor = .white
        subHeading.textAlignment = .left
        subHeading.adjustsFontSizeToFitWidth = true
        subHeading.font = .italicSystemFont(ofSize: 18)
        section1.addSubview(subHeading)
        
        let launchButton = UIButton(frame: CGRect(x: heading.frame.minX, y: subHeading.frame.maxY + 5, width: 150, height: 30))
        launchButton.tintColor = .white
        launchButton.setTitle("Launch Simulation", for: .normal)
        launchButton.addTarget(self, action: #selector(launchSimulation), for: .touchUpInside)
        launchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        launchButton.setTitleColor(topic.color, for: .normal)
        launchButton.backgroundColor = .white
        launchButton.layer.cornerRadius = 10
        section1.addSubview(launchButton)
        
        description1 = UILabel(frame: CGRect(x: 20, y: section1.frame.maxY, width: presentation.frame.width - 40, height: 70))
        description1.backgroundColor = .clear
        description1.text = "Get a glimpse of \(topic.title) with an interactive simulation called '\(topic.simulationName)'!"
        description1.textColor = .white
        description1.textAlignment = .left
        description1.adjustsFontSizeToFitWidth = true
        description1.numberOfLines = 0
        description1.font = .systemFont(ofSize: 18, weight: .regular)
        presentation.addSubview(description1)
        
    }
    
    func setupPracticeSection() {
        section2 = UIView(frame: CGRect(x: 10, y: description1.frame.maxY + 50, width: presentation.frame.width - 20, height: 100))
        section2.backgroundColor = .clear
        presentation.addSubview(section2)
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: section2.frame.height, height: section2.frame.height))
        image.image = topic.practiceImage
        image.contentMode = .scaleAspectFit
        section2.addSubview(image)
        
        let heading = UILabel(frame: CGRect(x: image.frame.maxX + 10, y: 0, width: section2.frame.width - image.frame.width - 10, height: 30))
        heading.text = "Practice Problems"
        heading.textColor = .white
        heading.textAlignment = .left
        heading.adjustsFontSizeToFitWidth = true
        heading.font = .systemFont(ofSize: 20, weight: .medium)
        section2.addSubview(heading)
        
        let subHeading = UILabel(frame: CGRect(x: heading.frame.minX, y: heading.frame.maxY, width: heading.frame.width, height: 30))
        subHeading.text = "0/10 Completed"
        subHeading.textColor = .white
        subHeading.textAlignment = .left
        subHeading.adjustsFontSizeToFitWidth = true
        subHeading.font = .italicSystemFont(ofSize: 18)
        section2.addSubview(subHeading)
        
        let launchButton = UIButton(frame: CGRect(x: heading.frame.minX, y: subHeading.frame.maxY + 5, width: 150, height: 30))
        launchButton.tintColor = .white
        launchButton.setTitle("Launch Practice", for: .normal)
        launchButton.addTarget(self, action: #selector(launchPractice), for: .touchUpInside)
        launchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        launchButton.setTitleColor(topic.color, for: .normal)
        launchButton.backgroundColor = .white
        launchButton.layer.cornerRadius = 10
        section2.addSubview(launchButton)
        
        description2 = UILabel(frame: CGRect(x: 20, y: section2.frame.maxY, width: presentation.frame.width - 40, height: 70))
        description2.backgroundColor = .clear
        description2.text = "Apply your knowledge of \(topic.title) with visual practice problems and step-by-step solutions!"
        description2.textColor = .white
        description2.textAlignment = .left
        description2.adjustsFontSizeToFitWidth = true
        description2.numberOfLines = 0
        description2.font = .systemFont(ofSize: 18, weight: .regular)
        presentation.addSubview(description2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func launchSimulation() {
        let simulation = topic.simulationVC
        simulation.modalPresentationStyle = .fullScreen
        let vc = findViewController() as! ViewController
        vc.present(simulation, animated: true)
    }
    
    @objc func launchPractice() {
        let practice = PracticeViewController()
        practice.topic = topic
        practice.modalPresentationStyle = .fullScreen
        let vc = findViewController() as! ViewController
        vc.present(practice, animated: true)
    }
    
    
    @objc func handleExit() {
        self.removeFromSuperview()
    }
    
    
}



extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
