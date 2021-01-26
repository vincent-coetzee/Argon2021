//
//  CastExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class CastExpression:Expression
    {
    let rhs:Expression
    let lhs:Expression
    
    init(lhs:Expression,rhs:Expression)
        {
        self.lhs = lhs
        self.rhs = rhs
        super.init()
        }
    }
