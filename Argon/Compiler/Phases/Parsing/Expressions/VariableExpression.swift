//
//  VariableExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class VariableExpression:AccessExpression
    {
    let variable:Variable
    
    public override var isHollowVariableExpression:Bool
        {
        return(self.variable.isHollowVariable)
        }
        
    init(variable:Variable)
        {
        self.variable = variable
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        let temp = A3Temporary.newTemporary()
        self.variable.generateIntermediateCodeLoad(target:.temporary(temp),into:buffer)
        }
    }
