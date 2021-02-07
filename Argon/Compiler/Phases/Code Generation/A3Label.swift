//
//  InstructionLabel.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public struct A3Label
    {
    static func newLabel() -> A3Label
        {
        return(A3Label(index:Argon.nextIndex()))
        }
        
    public var displayString:String
        {
        let string = String(format:"l_%06d",self.index)
        return(string)
        }
        
    public var index:Int
    public var instruction:A3Instruction?
        
    init(index:Int,instruction:A3Instruction? = nil)
        {
        self.index = index
        self.instruction = instruction
        }
        
    init()
        {
        self.index = Argon.nextIndex()
        self.instruction = nil
        }
        
    mutating func setInstruction(_ instruction:A3Instruction)
        {
        self.instruction = instruction
        }
    }

public typealias InstructionLabels = Array<A3Label>
