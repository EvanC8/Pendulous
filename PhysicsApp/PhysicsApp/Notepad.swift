//
//  Notepad.swift
//  PhysicsApp
//
//  Created by The Evanator on 10/10/22.
//

import UIKit
import PencilKit

class Notepad: UIView {
    
    var promptLabel: UILabel!
    var promptImage: UIImageView!
    var dismissPrompt: UIButton!
    
    var pad: PKCanvasView!
    var color = UIColor.black
    
    var currentTool = "Pencil"
    
    var isShowing = false
    var shownOnce = false
    var offset = 0.0
    
    let clearButton = UIButton()
    let backButton = UIButton()
    let colorButton = UIButton()
    let toolButton = UIButton()
    
    let colorMenu = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pad = PKCanvasView(frame: self.bounds)
        pad.drawing = PKDrawing()
        pad.backgroundColor = .white
        pad.tool = PKInkingTool(PKInkingTool.InkType.pencil, color: self.color, width: 5)
        if #available(iOS 14.0, *) {
            pad.drawingPolicy = .anyInput
        } else {
            pad.allowsFingerDrawing = true
        }
        pad.bounces = false
        pad.contentOffset = CGPoint(x: 0, y: 0)
        self.addSubview(pad)
        
        let header = UIView(frame: CGRect(x: 10, y: 0, width: self.frame.width - 20, height: 50))
        header.backgroundColor = .white
        self.addSubview(header)
        
        let spacer = UIView(frame: CGRect(x: 0, y: 50, width: self.frame.width, height: 2))
        spacer.backgroundColor = .black
        self.addSubview(spacer)
        
        backButton.frame = CGRect(x: header.frame.width / 2 - 45, y: 10, width: 90, height: 30)
        backButton.setImage(UIImage(named: "BackToQuestionIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        backButton.contentMode = .scaleAspectFit
        header.addSubview(backButton)
        
        clearButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        header.addSubview(clearButton)
        
        colorButton.frame = CGRect(x: header.frame.width - 50, y: 0, width: 50, height: 50)
        colorButton.tintColor = .black
        colorButton.addTarget(self, action: #selector(handleColorMenu), for: .touchUpInside)
        colorButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        header.addSubview(colorButton)
        
        toolButton.frame = CGRect(x: colorButton.frame.minX - 50, y: 0, width: 50, height: 50)
        toolButton.setImage(UIImage(named: "Pencil"), for: .normal)
        toolButton.addTarget(self, action: #selector(changeTool), for: .touchUpInside)
        header.addSubview(toolButton)
        
        let colorMenuWidth = self.frame.width * 0.7
        colorMenu.frame = CGRect(x: self.frame.width - colorMenuWidth - 10, y: 60, width: colorMenuWidth, height: colorMenuWidth * 0.5)
        colorMenu.isHidden = true
        colorMenu.backgroundColor = .white
        colorMenu.layer.borderWidth = 2
        colorMenu.layer.cornerRadius = 20
        colorMenu.layer.borderColor = UIColor.black.cgColor
        self.addSubview(colorMenu)
        
        let colors: [UIColor] = [.black, .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemPink]
        let boxSize = colorMenu.frame.height / 2
        let length = boxSize * 0.7
        let spacing = (boxSize - length) / 2
        for x in 0...7 {
            let button = UIButton()
            button.backgroundColor = colors[x]
            let xCoor = (boxSize * (CGFloat(x) - (x < 4 ? 0 : 4))) + spacing
            let yCoor = boxSize * floor(CGFloat(x/4)) + spacing
            button.frame = CGRect(x: xCoor, y: yCoor, width: length, height: length)
            button.layer.cornerRadius = length / 2
            button.addTarget(self, action: #selector(buttonChosenWithColor(_:)), for: .touchUpInside)
            colorMenu.addSubview(button)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clear() {
        pad.drawing = PKDrawing()
    }
    
    @objc func handleColorMenu() {
        colorMenu.isHidden = !colorMenu.isHidden
    }
    
    @objc func buttonChosenWithColor(_ button: UIButton) {
        setColor(newColor: button.backgroundColor!)
        colorButton.tintColor = button.backgroundColor!
        colorMenu.isHidden = true
    }
    
    func setColor(newColor: UIColor) {
        self.color = newColor
        if currentTool == "Pencil" { pad.tool = PKInkingTool(PKInkingTool.InkType.pencil, color: self.color, width: 5) }
    }
    
    @objc func changeTool() {
        if currentTool == "Pencil" {
            currentTool = "Eraser"
            pad.tool = PKEraserTool(.bitmap)
        }
        else {
            currentTool = "Pencil"
            pad.tool = PKInkingTool(PKInkingTool.InkType.pencil, color: self.color, width: 5)
        }
        toolButton.setImage(UIImage(named: currentTool), for: .normal)
    }
    
    @objc func hide() {
        animate(show: false, offset: self.offset)
    }
    
    @objc func handleDismissPrompt() {
        self.promptLabel.removeFromSuperview()
        self.promptImage.removeFromSuperview()
        self.dismissPrompt.removeFromSuperview()
    }
    
    func animate(show: Bool, offset: CGFloat) {
        self.offset = offset
        self.isShowing = show
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(translationX: 0, y: show == true ? -self.offset : self.offset)
        } completion: { _ in
            if self.isShowing == true && self.shownOnce == false {
                self.shownOnce = true
                self.promptLabel = UILabel()
                self.promptLabel.text = "You can use this drawing space to help you solve the question"
                self.promptLabel.textColor = .gray
                self.promptLabel.font = UIFont.systemFont(ofSize: 20)
                self.promptLabel.frame = CGRect(x: self.frame.width * 0.1, y: self.frame.height / 2 - 100, width: self.frame.width * 0.8, height: 100)
                self.promptLabel.numberOfLines = 0
                self.promptLabel.textAlignment = .center
                self.promptLabel.adjustsFontSizeToFitWidth = true
                self.addSubview(self.promptLabel)
                self.promptImage = UIImageView(frame: CGRect(x: self.frame.width / 2 - 50, y: self.promptLabel.frame.maxY, width: 100, height: 100))
                self.promptImage.contentMode = .scaleAspectFit
                self.promptImage.image = UIImage(named: "PencilWritingIcon.png")
                self.addSubview(self.promptImage)
                self.dismissPrompt = UIButton(frame: CGRect(x: self.frame.width / 2 - 35, y: self.promptImage.frame.maxY + 10, width: 70, height: 30))
                self.dismissPrompt.setTitle("Dismiss", for: .normal)
                self.dismissPrompt.setTitleColor(.gray, for: .normal)
                self.dismissPrompt.addTarget(self, action: #selector(self.handleDismissPrompt), for: .touchUpInside)
//                self.addSubview(self.dismissPrompt)
                
                UIView.animate(withDuration: 10) {
                    self.promptLabel.alpha = 0.2
                    self.promptImage.alpha = 0.2
                    self.dismissPrompt.alpha = 0.2
                } completion: { _ in
                    self.handleDismissPrompt()
                }
            }
        }
    }
    
}
