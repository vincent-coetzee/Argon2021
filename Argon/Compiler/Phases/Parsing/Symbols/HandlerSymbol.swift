//
//  HandlerSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/25.
//

import Foundation

public class HandlerSymbol:Symbol
    {
    internal let inductionVariable:InductionVariable
    internal let block:Block
    internal var codeBuffer = A3CodeBuffer()
    
    enum CodingKeys:String,CodingKey
        {
        case inductionVariable
        case codeBuffer
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.inductionVariable = try values.decode(InductionVariable.self,forKey:.inductionVariable)
        self.codeBuffer = try values.decode(A3CodeBuffer.self,forKey:.codeBuffer)
        self.block = Block()
        try super.init(from: values.superDecoder())
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.inductionVariable,forKey:.inductionVariable)
        try container.encode(self.codeBuffer,forKey:.codeBuffer)
        try super.encode(to: container.superEncoder())
        }
        
    init(shortName:String,inductionVariable:InductionVariable,block:Block)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        super.init(shortName:shortName)
        }
    }
