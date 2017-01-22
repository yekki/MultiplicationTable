//
//  ViewController.swift
//  MultiplicationTable
//
//  Created by Gary Niu on 2017/1/21.
//  Copyright © 2017年 Gary Niu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    let UNIT_SIZE:UInt = 5
    
    var index: UInt?
    var problems: Array<(UInt, UInt, UInt)>?
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
        levelLabel.text = "\(Int(roundedValue))"
    }
    
    func updateScreen(_ content: String) {
        screenTextField.text = content
    }
    
    //init app
    func initialize() {
        
        index = 1
        nextButton.setTitle("开始测试", for: UIControlState.normal)
        nextButton.tag = Step.Begin.rawValue
        
        resultLabel.text = "准备好了吗？小宝贝!💪"
        levelLabel.text = "5"
        
        answerTextField.isHidden = true
        answerLabel.isHidden = true
        answerButton.isHidden = true
        
        levelSlider.isHidden = false
        
        nextButton.frame.origin.x = 145
        nextButton.frame.origin.y = 419
        
        screenTextField.isHidden = true
        
        modeSwitch.setOn(true, animated: true)
    }
    
    func begin() {
        
        problems = genProblems(unitSize: UNIT_SIZE, level:levelLabel.text!, isSingle: !modeSwitch.isOn)
        
        showProblem()
        
        nextButton.setTitle("提交答案", for: UIControlState.normal)
        nextButton.tag = Step.Submit.rawValue
        nextButton.frame.origin.x = 72
        
        answerTextField.isHidden = false
        answerButton.isHidden = false
        
        levelSlider.isHidden = true

        screenTextField.isHidden = false

        resultLabel.text = ""
        answerTextField.text = ""
        modeSwitch.isEnabled = false
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
            nextButton.frame.origin.y = 419
            answerButton.isHidden = true
            answerTextField.resignFirstResponder()

        } else {
            resultLabel.text = "你的答案不对哟，再想想？☹️"
        }
    }
    
    func end() {
        initialize()
        resultLabel.text = "恭喜你，全部答完了！🏅"
        modeSwitch.isEnabled = true
    }
    
    func showProblem() {
        let currentProblem = problems![Int(index!-1)]
        updateScreen(String(currentProblem.0) + " x " + String(currentProblem.1) + " = ?")
        updateIndex()
        nextButton.setTitle("提交答案", for: UIControlState.normal)
        nextButton.tag = Step.Submit.rawValue
        answerTextField.becomeFirstResponder()
    }
    
    func updateIndex() {
        indexLabel.text = "第 \(index!) 题"
    }
    
    func next() {
        index! += 1
        
        if index! > UNIT_SIZE {
            end()
        }
        else {
            showProblem()
            nextButton.frame.origin.x = 72
            nextButton.frame.origin.y = 419
            answerTextField.isHidden = false
            answerTextField.text = ""
            answerLabel.isHidden = false
            answerButton.isHidden = false
            resultLabel.text = ""
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
        
        resultLabel.text = "答案是：" + String(Int((problems?[Int(index! - 1)].2)!)) + "！ 这样可不好哟！🐶"
    }
    
    @IBAction func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            modeLabel.text = "模式:多"
        }
        else {
            modeLabel.text = "模式:单"
        }
    }
}

