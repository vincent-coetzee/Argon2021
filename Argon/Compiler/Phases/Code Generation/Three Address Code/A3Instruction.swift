//
//  ThreeAddressInstruction.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class A3Instruction:Instruction,Codable
    {
    internal enum InstructionCode:String,Codable
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
    
    enum CodingKeys:String,CodingKey
        {
        case result
        case left
        case right
        case opcode
        case id
        case labels
        case location
        case comment
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.labels = try values.decode(Array<A3Label>.self,forKey:.labels)
        self.result = try values.decode(A3Address?.self,forKey:.result)
        self.location = try values.decode(SourceLocation?.self,forKey:.location)
        self.left = try values.decode(A3Address?.self,forKey:.left)
        self.right = try values.decode(A3Address?.self,forKey:.right)
        self.comment = try values.decode(String?.self,forKey:.comment)
        self.opcode = try values.decode(InstructionCode.self,forKey:.opcode)
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.labels,forKey:.labels)
        try container.encode(self.result,forKey:.result)
        try container.encode(self.location,forKey:.location)
        try container.encode(self.left,forKey:.left)
        try container.encode(self.right,forKey:.right)
        try container.encode(self.comment,forKey:.comment)
        try container.encode(self.opcode,forKey:.opcode)
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
