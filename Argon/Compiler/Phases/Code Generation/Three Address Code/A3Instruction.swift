//
//  ThreeAddressInstruction.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class A3Instruction:Instruction,CustomDebugStringConvertible
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
        case greaterthanequal
        case lessthan
        case lessthanequal
        case branchIfTrue
        case branchIfFalse
        case branch
        case nop
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
        case parameter
        case syscall
        }
        
    let result:A3Address?
    let left:A3Address?
    let right:A3Address?
    let opcode:InstructionCode
    public var labels = InstructionLabels()
    public var location:SourceLocation?
    public var comment:String?
        
    public var debugDescription:String
        {
        return(self.displayString)
        }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
        
    init(label:A3Label? = nil,result:A3Address? = nil,left:A3Address? = nil,opcode:InstructionCode,right:A3Address? = nil,comment:String? = nil)
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

    public func addLabel(_ label:A3Label)
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
            string += "                   ## \(self.right!.displayString)\n"
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
        if self.opcode == .assign
            {
            return(self.stringAdjustedForComment(string))
            }
        string += "\(opcode.rawValue.uppercased()) "
        if let right = self.right
            {
            string += "\(right.displayString)"
            }
        return(self.stringAdjustedForComment(string))
        }
    }
