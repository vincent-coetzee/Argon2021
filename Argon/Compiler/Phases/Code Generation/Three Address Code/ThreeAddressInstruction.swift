//
//  ThreeAddressInstruction.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class ThreeAddressInstruction:Instruction
    {
    internal enum InstructionCode
        {
        case add
        case sub
        case mul
        case div
        case mod
        case enter
        case leave
        case not
        case and
        case or
        case bitAnd
        case bitNot
        case bitOr
        case pow
        case bitXor
        case bitShiftLeft
        case bitShiftRight
        case mulEquals
        case subEquals
        case addEquals
        case divEquals
        case bitAndEquals
        case bitOrEquals
        case bitNotEquals
        case bitXorEquals
        case shiftLeftEquals
        case shiftRightEquals
        case equals
        case notEquals
        case copy
        case greater
        case branchIfTrue
        case branchIfFalse
        case branch
        case nop
        case parameter
        case call
        case slot
        case address
        case assign
        }
        
    let result:ThreeAddress?
    let left:ThreeAddress?
    let right:ThreeAddress?
    let opcode:InstructionCode
    public var labels = InstructionLabels()
    
    init(label:InstructionLabel? = nil,result:ThreeAddress? = nil,left:ThreeAddress,opcode:InstructionCode,right:ThreeAddress? = nil)
        {
        self.result = result
        self.left = left
        self.opcode = opcode
        self.right = right
        if let theLabel = label
            {
            self.labels.append(theLabel)
            }
        }
        
    init(opcode:InstructionCode)
        {
        self.result = nil
        self.left = nil
        self.opcode = opcode
        self.right = nil
        }

    public func addLabel(_ label:InstructionLabel)
        {
        self.labels.append(label)
        }
        
    var displayString:String
        {
        var string = ""
        if !self.labels.isEmpty
            {
            for label in self.labels
                {
                string += "LABEL_\(label.index):\n"
                }
            }
        if let result = self.result
            {
            string += "\(result)"
            }
        if let left = self.left
            {
            string += " \(left)"
            }
        string += " \(opcode) "
        if let right = self.right
            {
            string += "\(right)"
            }
        return(string)
        }
    }
