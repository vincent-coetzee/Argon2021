//
//  FunctionExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class FunctionExpression:ExecutableExpression
    {
    public override var typeClass:Class
        {
        return(Class.functionClass)
        }
        
    let name:String
    let function:Function?
    
    init(name:String,function:Function?)
        {
        self.name = name
        self.function = function
        super.init()
        }
    }
