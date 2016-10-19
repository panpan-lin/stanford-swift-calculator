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
    
    private var userSettingVar = false
    
    private var savedProgram: CalculatorBrain.PropertyList?
    
    @IBOutlet private weak var showResult: UILabel!
    
    @IBOutlet private weak var showCalHist: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
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
    
    private var displayValue: Double{
        get {
            return Double(showResult.text!)!
        }
        set {
            showResult.text = String(newValue)
        }
    }

    private var displayHistory: String{
        get {
            return String(showCalHist.text!)!
        }
        set {
            showCalHist.text = String(newValue)
        }
    }
    
    @IBAction private func clearDisplay() {
        brain.clear()
        updateDisplay()
        userInTheMiddleOfTyping = false
    }
    
    @IBAction private func touchConstant(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            brain.addToCalculationHistory(lastEntry: String(displayValue))
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
            brain.addToCalculationHistory(lastEntry: sender.currentTitle!)
        }
        updateDisplay()
    }
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func resotre() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func touchSetVar() {
        userSettingVar = true
        displayValue = 0.0
        userInTheMiddleOfTyping = false
    }
    
    @IBAction func touchVar(_ sender: UIButton) {
        let variableName = sender.currentTitle!
        if userSettingVar {
            // not a good implementation, for constant or expression / operand
            brain.variableValues[variableName] = displayValue
            userSettingVar = false
            displayValue = 0
            displayHistory = " "
        } else {
            if (brain.variableValues[variableName] != nil) {
                displayValue = brain.variableValues[variableName]!
            } else {
                displayValue = 0.0
            }
            userInTheMiddleOfTyping = true
        }
    }
    
    private func updateDisplay(){
        displayValue = brain.result
        displayHistory = brain.description
    }
    
}

