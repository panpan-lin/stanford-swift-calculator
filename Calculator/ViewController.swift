//
//  ViewController.swift
//  Calculator
//
//  Created by Panpan Lin on 18/10/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    private var userInTheMiddleOfTyping = false
    
    @IBOutlet weak var showResult: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if !userInTheMiddleOfTyping {
            if digit != "." {
                showResult.text = digit
            } else {
                showResult.text = "0."
            }
        } else {
            if (digit != ".") || (!showResult.text!.contains(".")) {
                showResult.text = showResult.text! + digit
            }
        }
        userInTheMiddleOfTyping = true
    }
    
    var displayValue: Double{
        get {
            return Double(showResult.text!)!
        }
        set {
            showResult.text = String(newValue)
        }
    }
    
    @IBAction private func touchConstant(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
}

