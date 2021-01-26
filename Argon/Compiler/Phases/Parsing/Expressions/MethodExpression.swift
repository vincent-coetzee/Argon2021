//
//  MethodExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class MethodExpression:ExecutableExpression
    {
    let method:Method
    
    init(method:Method)
        {
        self.method = method
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try method.allocateAddresses(using:compiler)
        }
    }
