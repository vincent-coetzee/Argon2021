//
//  Argument.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Argument:Symbol,ThreeAddress
    {
    public var displayString:String
        {
        return(self.tag ?? "argument\(self.argumentIndex)")
        }
        
    internal var value:Expression
    internal var tag:String?
    internal var argumentIndex:Int
    
    internal override var typeClass:Class
        {
        return(value.typeClass)
        }
        
    internal init(tag:String? = nil,value:Expression,index:Int)
        {
        self.tag = tag
        self.value = value
        self.argumentIndex = index
        super.init(shortName: tag ?? "")
        }
    
    internal required init()
        {
        self.value = Expression()
        self.tag = nil
        self.argumentIndex = 0
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        try value.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        }
        
    internal func generateIntermediatePushCode(into buffer:ThreeAddressInstructionBuffer)
        {
        self.value.generateIntermediatePushCode(into:buffer)
        }
    }


internal class NakedArgument:Argument
    {
    }

public typealias Arguments = Array<Argument>

extension Arguments
    {
    func typesPrefixed(by:Type) -> [Type]
        {
        var types = self.map{$0.type}
        types.append(by)
        return(types)
        }
    }
