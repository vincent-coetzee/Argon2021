//
//  LiteralArrayExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralArrayExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.arrayClass)
        }
        
    let array:[Expression]
    
    init(array:[Expression])
        {
        self.array = array
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        for element in self.array
            {
            try element.allocateAddresses(using:compiler)
            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {

        }
    }
