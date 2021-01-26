//
//  UnaryExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class UnaryExpression:Expression
    {
    let lhs:Expression
    let operation:Token.Symbol
    
    init(lhs:Expression,operation:Token.Symbol)
        {
        self.lhs = lhs
        self.operation = operation
        super.init()
        }
    }
