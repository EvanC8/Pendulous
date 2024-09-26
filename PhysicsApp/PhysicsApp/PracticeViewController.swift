//
//  PracticeViewController.swift
//  PhysicsApp
//
//  Created by The Evanator on 10/8/22.
//

import UIKit

class PracticeViewController: UIViewController {
    
    var topic: Topic!
    
    let header = UIView()
    let questionSelection = UIView()
    let footer = UIView()
    let answerSubmission = UIView()
    
    var notepad: Notepad!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        setupHeader()
        
        setupQuestionSelection()
        
        setupFooter()
        
        setupAnswerInput()
        
        setupProblem()
        
        setupNotepad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    //MARK: SECTIONS
    
    func setupHeader() {
        let topPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 30.0
        let height = 30.0
        
        header.frame = CGRect(x: 10, y: topPadding + 10, width: view.frame.width - 20.0, height: height)
        view.addSubview(header)
        
        exitButton.frame = CGRect(x: 0, y: 0, width: height, height: height)
        exitButton.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        header.addSubview(exitButton)
        
        progressBar.frame = CGRect(x: 60, y: height/2 - 2.5, width: header.frame.width - 120.0, height: 5)
        progressBar.tintColor = .systemBlue
        progressBar.progress = 0.1
        header.addSubview(progressBar)
        
        questionIndicator.frame = CGRect(x: header.frame.width - 50, y: 0, width: 50, height: 30)
        questionIndicator.text = "1/10"
        header.addSubview(questionIndicator)
        
        let spacer = UIView(frame: CGRect(x: view.frame.width * 0.05, y: header.frame.maxY + 10, width: view.frame.width * 0.9, height: 1))
        spacer.backgroundColor = .tertiaryLabel
        view.addSubview(spacer)
    }
    
    func setupQuestionSelection() {
        let height = 50.0
        
        questionSelection.frame = CGRect(x: 10, y: header.frame.maxY + 20.0, width: view.frame.width - 20.0, height: height)
        view.addSubview(questionSelection)
        
        previousQuestion.frame = CGRect(x: 0, y: 0, width: height, height: height)
        questionSelection.addSubview(previousQuestion)
        
        nextQuestion.frame = CGRect(x: questionSelection.frame.width - height, y: 0, width: height, height: height)
        questionSelection.addSubview(nextQuestion)
        
        questionTitle.frame = CGRect(x: previousQuestion.frame.maxX + 10, y: 0, width: questionSelection.frame.width - (previousQuestion.frame.width * 2) - 20, height: 50)
        questionSelection.addSubview(questionTitle)
        questionTitle.text = "Risk-Taking Racecar"
        
    }
    
    func setupProblem() {
//        let height = (answerSubmission.frame.minY - 50 - questionSelection.frame.maxY - 20) / 2
        
        let visualHeight = (view.frame.width - 40) / 16 * 9
        problemVisual.frame = CGRect(x: 20, y: answerSubmission.frame.minY - 20 - visualHeight, width: view.frame.width - 40, height: visualHeight)
        problemVisual.image = UIImage(named: "PrePractice1")
        view.addSubview(problemVisual)
        
        problemText.frame = CGRect(x: 20, y: questionSelection.frame.maxY, width: view.frame.width - 40, height: problemVisual.frame.minY - questionSelection.frame.maxY - 20)
        problemText.text = "A red racecar is traveling at 15 meters per second and is 25 meters away from an upcoming stoplight that has just turned yellow. The driver has to slow the car with a constant acceleration such that the car stops right at the stoplight. What should be the acceleration of the racecar?"
        view.addSubview(problemText)
    }
    
    func setupAnswerInput() {
        let height = 40.0
        
        answerSubmission.frame = CGRect(x: 50, y: footer.frame.minY - height - 50, width: view.frame.width - 100.0, height: height)
        view.addSubview(answerSubmission)
        
        answerField.frame = CGRect(x: 0, y: 0, width: 100, height: height)
        answerField.addDoneCancelToolbar(label: extraFieldLabel)
        answerField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        answerSubmission.addSubview(answerField)
        
        unitsLabel.frame = CGRect(x: answerField.frame.maxX + 5.0, y: 0, width: 50, height: height)
        answerSubmission.addSubview(unitsLabel)
        unitsLabel.text = "units"
        
        submitButton.frame = CGRect(x: answerSubmission.frame.width - 100.0, y: 0, width: 100, height: height)
        submitButton.backgroundColor = .systemBlue
        answerSubmission.addSubview(submitButton)
        
    }
    
    func setupFooter() {
        let height: CGFloat = 35
        let bottomPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 30.0
        
        footer.frame = CGRect(x: 10, y: view.frame.height - bottomPadding - height - 10, width: view.frame.width - 20, height: 30)
        view.addSubview(footer)
        
        hintButton.frame = CGRect(x: 0, y: 0, width: 100, height: height)
        hintButton.layer.borderColor = UIColor.systemRed.cgColor
        hintButton.tintColor = .systemRed
        hintButton.setTitleColor(.systemRed, for: .normal)
        footer.addSubview(hintButton)
        
        solutionButton.frame = CGRect(x: footer.frame.width - 100, y: 0, width: 100, height: height)
        solutionButton.layer.borderColor = UIColor.systemGreen.cgColor
        solutionButton.tintColor = .systemGreen
        solutionButton.setTitleColor(.systemGreen, for: .normal)
        footer.addSubview(solutionButton)
        
        notepadButton.frame = CGRect(x: footer.frame.width / 2 - 45, y: 0, width: 90, height: height)
        notepadButton.addTarget(self, action: #selector(handleNotepad), for: .touchUpInside)
        footer.addSubview(notepadButton)
    }
    
    func setupNotepad() {
        let bottomPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        let topPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        notepad = Notepad(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - bottomPadding - topPadding))
        view.addSubview(notepad)
    }
    
    //MARK: OBJC FUNCTIONS
    
    @objc func handleExit() {
        dismiss(animated: true)
    }
    
    @objc func handleNotepad() {
        let topPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        notepad.animate(show: !notepad.isShowing, offset: view.frame.height - topPadding)
    }
    
    //MARK: VARIABLES
    
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .light)), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .default)
        return bar
    }()
    
    let questionIndicator: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .thin)
        return label
    }()
    
    let previousQuestion: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        button.tintColor = .tertiaryLabel
        return button
    }()
    
    let nextQuestion: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let questionTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 25)
        return label
    }()
    
    let problemText: UITextView = {
        let view = UITextView()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        view.typingAttributes = attributes
        view.textColor = .black
        view.textAlignment = .left
        view.isEditable = false
        view.backgroundColor = .white
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return view
    }()
    
    let problemVisual: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let hintButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitle("Get Hint", for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    let solutionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitle("Solution", for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    let notepadButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(named: "NotepadIcon"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let answerField: UITextField = {
        let field = UITextField()
        field.adjustsFontSizeToFitWidth = true
        field.font = .systemFont(ofSize: 15, weight: .regular)
        field.backgroundColor = .white
        field.textColor = .black
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Answer", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        field.returnKeyType = .done
        field.textAlignment = .center
        field.adjustsFontSizeToFitWidth = true
        field.keyboardType = .decimalPad
        return field
    }()
    
    let extraFieldLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Enter Answer"
        label.textAlignment = .center
        return label
    }()
    
    let unitsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()

}

// MARK: TEXT FIELD METHODS

extension PracticeViewController: UITextFieldDelegate {
    
    @objc func didChangeText() {
        extraFieldLabel.text = answerField.text
        if answerField.text == "" { extraFieldLabel.text = "Enter Answer" }
    }
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil, label: UILabel) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
//            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        label.frame = CGRect(x: 10, y: 0, width: 100, height: toolbar.frame.height)
        toolbar.addSubview(label)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
