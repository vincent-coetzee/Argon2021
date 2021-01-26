//
//  TuleExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation


public class TupleExpression:VectorExpression
    {
    let elements:[Expression]
    
    init(elements:[Expression])
        {
        self.elements = elements
        super.init()
        }
    }
    
