//
//  Brain.swift
//  MultiplicationTable
//
//  Created by 牛秀元 on 2017/1/22.
//  Copyright © 2017年 Gary Niu. All rights reserved.
//

import Foundation

func genRandomNum(_ max:UInt) -> UInt {
    return UInt(arc4random_uniform(UInt32(max)))+1
}

func genNumber(max:UInt, isSingle: Bool) -> UInt {
    
    if isSingle {
        return max
    }
    else {
        return genRandomNum(max)
    }
}
func genProblems(unitSize:UInt, level: String, isSingle: Bool) -> Array<(UInt, UInt, UInt)> {
    
    let l = UInt(level)
    var array:Array<(UInt, UInt, UInt)> = Array<(UInt, UInt, UInt)>()
    
    for _ in 1...unitSize {
        var num1 = genNumber(max:l!, isSingle: isSingle)
        var num2 = genRandomNum(9)
        var isExist: Bool = false
        
        for n in array {
            
            repeat {
                if n.2 == num1 * num2 {
                    isExist = true
                    num1 = genNumber(max:l!, isSingle: isSingle)
                    num2 = genRandomNum(9)
                }
                else {
                    isExist = false
                }
            } while isExist
        }
        array.append((num1, num2, num1*num2))
    }
    
    return array
}

func isCorrectAnswer(problem:(UInt, UInt, UInt), answer:String)->Bool {
    let answer = UInt(answer)
    return answer == problem.2
}

