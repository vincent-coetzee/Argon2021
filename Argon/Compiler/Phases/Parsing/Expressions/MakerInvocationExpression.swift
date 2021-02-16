//
//  MakerInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class MakerInvocationExpression:InvocationExpression
    {
    var theClass:Class?
    let arguments:Arguments
    var bitSet:BitSet?
    var enumeration:Enumeration?
    
    init(class:Class,arguments:Arguments)
        {
        self.theClass = `class`
        self.arguments = arguments
        super.init()
        }
        
    init(bitSet:BitSet,arguments:Arguments)
        {
        self.bitSet = bitSet
        self.arguments = arguments
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try arguments.allocateAddresses(using:compiler)
        }
    }
