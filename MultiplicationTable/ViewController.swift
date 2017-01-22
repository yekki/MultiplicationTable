//
//  ViewController.swift
//  MultiplicationTable
//
//  Created by Gary Niu on 2017/1/21.
//  Copyright © 2017年 Gary Niu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var unitSizeSlider: UISlider!
    @IBOutlet weak var unitSizeLabel: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var levelSlider: UISlider!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var screenTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    enum Step: Int {
        case Begin = 1, Submit, Next
    }
        
    var index: UInt?
    var wrongCount: UInt?
    var problems: Array<(UInt, UInt, UInt)>?
    var wrongProblems: Array<(UInt, UInt, UInt)>?
    var isSingleMode: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeLevel(_ sender: UISlider) {
        //step is 1
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        
        switch sender.tag {
        case 1:
            levelLabel.text = "难度：\(Int(roundedValue))"
        case 2:
            unitSizeLabel.text = "题数：\(Int(roundedValue))"
        default:()
        }
    }
    
    func updateScreen(_ content: String) {
        screenTextField.text = content
    }
    
    //init app
    func initialize() {
        
        index = 1
        nextButton.setTitle("开始测试", for: UIControlState.normal)
        nextButton.tag = Step.Begin.rawValue
        
        resultLabel.text = "准备好了吗，妞妞？💡"
        
        answerTextField.isHidden = true
        answerLabel.isHidden = true
        answerButton.isHidden = true
        
        resultLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        resultLabel.numberOfLines = 0
        
        levelSlider.isHidden = false
        
        nextButton.frame.origin.x = 145
        
        screenTextField.isHidden = true
        
        showPanel(true)
    }
    
    func begin() {
        
        
        problems = genProblems(unitSize: parseNum(unitSizeLabel.text!), level:parseNum(levelLabel.text!), isSingle: !modeSwitch.isOn)
        
        wrongProblems = Array<(UInt, UInt, UInt)>()
        
        showProblem()
        
        nextButton.setTitle("提交答案", for: UIControlState.normal)
        nextButton.tag = Step.Submit.rawValue
        nextButton.frame.origin.x = 72
        
        answerTextField.isHidden = false
        answerButton.isHidden = false
        screenTextField.isHidden = false

        resultLabel.text = ""
        answerTextField.text = ""
        
        wrongCount = 0
        
        showPanel(false)
    }
        
    func showPanel(_ show:Bool) {
        
        if show {
            unitSizeLabel.isHidden = false
            unitSizeSlider.isHidden = false
            
            levelLabel.isHidden = false
            levelSlider.isHidden = false
            
            modeLabel.isHidden = false
            modeSwitch.isHidden = false
            
            settingLabel.isHidden = false
            
            changeLevel(levelSlider)
            changeLevel(unitSizeSlider)
            switchMode(modeSwitch)
        }
        else {
            settingLabel.isHidden = true
            unitSizeLabel.isHidden = true
            unitSizeSlider.isHidden = true
            
            levelLabel.isHidden = true
            levelSlider.isHidden = true
            
            modeLabel.isHidden = true
            modeSwitch.isHidden = true
        }
    }
    
    func submit() {
        
        let currentProblem = problems![Int(index!-1)]
        if isCorrectAnswer(problem: currentProblem, answer:answerTextField.text!) {
            resultLabel.text = "你答对了，妞妞宝贝儿！😀"
            answerTextField.isHidden = true
            answerLabel.isHidden = true
            nextButton.setTitle("下一题", for: UIControlState.normal)
            nextButton.tag = Step.Next.rawValue
            nextButton.frame.origin.x = 145
            answerButton.isHidden = true
            answerTextField.resignFirstResponder()
            wrongCount = 0
            updateScreen(String(currentProblem.0) + " x " + String(currentProblem.1) + " = \(currentProblem.2)")

        } else {
            wrongCount! += 1
            answerTextField.text = ""
            
            if wrongCount == 1 {
                
                if resultLabel.text == "" {
                    resultLabel.text = " 妞妞，你还没输入答案呢！☹️"
                }
                else {
                    resultLabel.text = "你的答案不对哟，再想想？☹️"
                }
                wrongProblems?.append(currentProblem)
            }
        }
    }
    
    func end() {
        
        initialize()
        
        let score = 100 - lroundf(Float(wrongProblems!.count)/Float(parseNum(unitSizeLabel.text!))*100)
        let badge = String(repeating: "🏅", count: lroundf(Float(score)/Float(100)*10)/2)
        resultLabel.text = "你的得分：\(score)\n" + badge
        indexLabel.text = ""
    }
    
    func showProblem() {
        
        let currentProblem = problems![Int(index!-1)]
        updateScreen(String(currentProblem.0) + " x " + String(currentProblem.1) + " = ?")
        updateIndex()
        nextButton.setTitle("提交答案", for: UIControlState.normal)
        nextButton.tag = Step.Submit.rawValue
        answerTextField.becomeFirstResponder()
        
        nextButton.frame.origin.x = 72
        answerTextField.isHidden = false
        answerTextField.text = ""
        answerLabel.isHidden = false
        answerButton.isHidden = false
        resultLabel.text = ""
    }
    
    func updateIndex() {
        indexLabel.text = "第 \(index!) 题"
    }
    
    func next() {
        
        index! += 1
        
        if index! > parseNum(unitSizeLabel.text!) {
            end()
        }
        else {
            showProblem()
            
        }
    }
    
    @IBAction func nextProblem(_ sender: UIButton) {
        
        switch Step.init(rawValue: sender.tag)! {
            case .Begin: begin()
            case .Submit: submit()
            case .Next: next()
        }
    }
    
    @IBAction func showAnswer(_ sender: Any) {

        resultLabel.text = "答案是：" + String(Int((problems?[Int(index! - 1)].2)!)) + "\n 这样可不好哟！🐶"
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            modeLabel.text = "模式：多"
        }
        else {
            modeLabel.text = "模式：单"
        }
    }
}

