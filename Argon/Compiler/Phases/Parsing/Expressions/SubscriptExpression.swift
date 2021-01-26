//
//  SubscriptExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class SubscriptExpression:AccessExpression
    {
    let target:Expression
    let `subscript`:Expression
    
    init(target:Expression,`subscript`:Expression)
        {
        self.target = target
        self.`subscript` = `subscript`
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitComment("Need to generate code for subscript access")
        }
    }
    
