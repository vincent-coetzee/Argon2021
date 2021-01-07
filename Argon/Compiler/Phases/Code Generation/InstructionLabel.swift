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
        return("LABEL\(index)")
        }
        
    public let index:Int
    public var instruction:Instruction?
    
    init(index:Int,instruction:Instruction? = nil)
        {
        self.index = index
        self.instruction = instruction
        }
        
    mutating func setInstruction(_ instruction:Instruction)
        {
        self.instruction = instruction
        }
    }

public typealias InstructionLabels = Array<InstructionLabel>
