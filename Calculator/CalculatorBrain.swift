//
//  Model.swift
//  Calculator
//
//  Created by Panpan Lin on 18/10/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator = 0.0
    
    var description = ""
    
    private var isPartialResult = true
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "+": Operation.BinaryOperation({ $0 + $1}),
        "-": Operation.BinaryOperation({ $0 - $1}),
        "×": Operation.BinaryOperation({ $0 * $1}),
        "÷": Operation.BinaryOperation({ $0 / $1}),
        "±": Operation.UnaryOperation({ -$0 }),
        "=": Operation.Equals
    ]

    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }

    func performOperation(symbol: String) {
        if let operation =  operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                isPartialResult = false
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        description = ""
        isPartialResult = true
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func addToCalculationHistory(lastEntry: String){
        if (isPartialResult && lastEntry != "="){
            description = description + String(lastEntry)
        } else if (!isPartialResult && lastEntry != "="){
            description = "(" + description + ")" + String(lastEntry)
            isPartialResult = true
        }
    }
    
    var result: Double{
        get {
            return accumulator
        }
    }
}
