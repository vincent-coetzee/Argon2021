//
//  InstructionLabel.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public struct InstructionLabel:ThreeAddress
    {
    static func newLabel() -> InstructionLabel
        {
        return(InstructionLabel(index:Argon.nextIndex()))
        }
        
    public var displayString:String
        {
        let string = String(format:"l_%06d",self.index)
        return(string)
        }
        
    public let index:Int
    public var instruction:Instruction?
    
    init(index:Int,instruction:Instruction? = nil)
        {
        self.index = index
        self.instruction = instruction
        }
        
    init()
        {
        self.index = Argon.nextIndex()
        self.instruction = nil
        }
        
    public func write(file: ObjectFile) throws
        {
        try file.write(character:"L")
        try file.write(self.index)
        }
        
    mutating func setInstruction(_ instruction:Instruction)
        {
        self.instruction = instruction
        }
    }

public typealias InstructionLabels = Array<InstructionLabel>
