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
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        for element in self.elements
            {
            try element.allocateAddresses(using:compiler)
            }
        fatalError("Logic should have been added here")
        }
    }
    
