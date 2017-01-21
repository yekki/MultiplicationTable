//
//  ViewController.swift
//  MultiplicationTable
//
//  Created by Gary Niu on 2017/1/21.
//  Copyright © 2017年 Gary Niu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var levelSlider: UISlider!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var screenTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var index: UInt?
    var problems: Array<(UInt, UInt, UInt)>?
    var currentProblem: (UInt, UInt, UInt)?
    
    let levelStep: Float = 1
    let unitSize:UInt = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newUnit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showProblem() {
        
        currentProblem = problems![Int(index!)]
        screenTextField.text = String(currentProblem!.0) + " x " + String(currentProblem!.1) + " = ?"
        nextButton.setTitle("答好了", for: UIControlState.normal)
        answerTextField.isHidden = false
        answerButton.isHidden = false
        nextButton.frame.origin.x = 72
        levelSlider.isHidden = true
        indexLabel.text = "第 \(index! + 1) 题"
    }
    
    func genProblemUnit(size: UInt, level: UInt) -> Array<(UInt, UInt, UInt)> {
        
        var array:Array<(UInt, UInt, UInt)> = Array<(UInt, UInt, UInt)>()
        
        for _ in 1...size {
            let num1 = UInt(arc4random_uniform(UInt32(level)))+1
            let num2 = UInt(arc4random_uniform(9))+1
            array.append((num1, num2, num1*num2))
        }
        
        return array
    }

    @IBAction func changeLevel(_ sender: UISlider) {

        let roundedValue = round(sender.value / levelStep) * levelStep
        sender.value = roundedValue
        levelLabel.text = "\(Int(roundedValue))"
    }
    
    func newUnit() {
        
        index = 0
        nextButton.setTitle("开始测试", for: UIControlState.normal)
        resultLabel.text = "准备好了吗？小宝贝!💪"
        
        answerTextField.isHidden = true
        answerLabel.isHidden = true
        
        answerButton.isHidden = true
        nextButton.frame.origin.x = 145
        nextButton.frame.origin.y = 419
        
        levelLabel.text = "5"
    }
    
    func checkAnswer()->Bool {
        let answer = UInt(answerTextField.text!)
        return answer == problems![Int(index!)].2
    }
    
    @IBAction func next(_ sender: Any) {

        if nextButton.currentTitle == "开始测试" {
            let level = UInt(levelLabel.text!)
            problems = genProblemUnit(size: unitSize, level:level!)
            showProblem()
        }
        else if nextButton.currentTitle == "答好了" {
            if checkAnswer() {
                index = index! + 1
                resultLabel.text = "你答对了，妞妞宝贝儿🏅"
                answerTextField.isHidden = true
                answerLabel.isHidden = true
                nextButton.setTitle("下一题", for: UIControlState.normal)
            } else {
                resultLabel.text = "你的答案不对哟，再想想？☹️"
            }
        }
        else if nextButton.currentTitle == "下一题" {
            
            if index! == unitSize {
                newUnit()
                resultLabel.text = ""
                screenTextField.text = ""
            }
            else {
                showProblem()
            }
        }
        
        answerTextField.text = ""
    }

    
    @IBAction func showAnswer(_ sender: Any) {
        
        resultLabel.text = "答案是：" + String(Int((problems?[Int(index! - 1)].2)!)) + " 这样可不好哟！🐶"
    }
}

