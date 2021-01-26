//
//  InstructionLabel.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public struct A3Label:Codable
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
        
    enum CodingKeys:String,CodingKey
        {
        case index
        case instruction
        }
        
    public init(from decoder:Decoder) throws
        {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try values.decode(Int.self,forKey:.index)
        self.instruction = try values.decode(A3Instruction.self,forKey:.instruction)
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.index,forKey:.index)
        try container.encode(self.instruction,forKey:.instruction)
        }
        
    mutating func setInstruction(_ instruction:A3Instruction)
        {
        self.instruction = instruction
        }
    }

public typealias InstructionLabels = Array<A3Label>
