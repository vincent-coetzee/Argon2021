//
//  ThreeAddressInstruction.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class ThreeAddressInstruction:Instruction
    {
    internal enum InstructionCode:String
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
        case assign
        case greaterthan
        case branchIfTrue
        case branchIfFalse
        case branch
        case nop
        case push
        case pop
        case call
        case slot
        case addressOf
        case invoke
        case invokeAddress
        case loadSuperAddress
        case loadThisAddress
        case loadTHISAddress
        case setWordAtAddress
        case ret
        case comment
        case mov
        case offsetIntoStack
        }
        
    let result:ThreeAddress?
    let left:ThreeAddress?
    let right:ThreeAddress?
    let opcode:InstructionCode
    public var labels = InstructionLabels()
    public var location:SourceLocation?
    public var comment:String?
    
    init(label:InstructionLabel? = nil,result:ThreeAddress? = nil,left:ThreeAddress? = nil,opcode:InstructionCode,right:ThreeAddress? = nil,comment:String? = nil)
        {
        self.result = result
        self.left = left
        self.opcode = opcode
        self.right = right
        if let theLabel = label
            {
            self.labels.append(theLabel)
            }
        self.comment = comment
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
        
    public func setLocation(_ label:SourceLocation)
        {
        self.location = label
        }
        
    private func stringAdjustedForComment(_ string:String) -> String
        {
        if self.comment == nil
            {
            return(string)
            }
        let extra = 50 - string.count
        var newString = string
        for _ in 0..<extra
            {
            newString += " "
            }
        return(newString + "// " + self.comment!)
        }
        
    var displayString:String
        {
        var string = ""
        if let position = self.location
            {
            let line = String(format:"%05d",position.line)
            string += "\(line)  "
            }
        else
            {
            string += "       "
            }
        if self.opcode == .comment
            {
            string += "            ##\n"
            string += "                   ## \(self.right ?? "")\n"
            string += "                   ##"
            return(self.stringAdjustedForComment(string))
            }
        if !self.labels.isEmpty
            {
            for label in self.labels
                {
                string += "\(label.displayString):   "
                }
            }
        else
            {
            string += "            "
            }
        if let result = self.result
            {
            string += "\(result.displayString) = "
            }
        if let left = self.left
            {
            string += "\(left.displayString) "
            }
        string += "\(opcode.rawValue.uppercased()) "
        if let right = self.right
            {
            string += "\(right.displayString)"
            }
        return(self.stringAdjustedForComment(string))
        }
    }
