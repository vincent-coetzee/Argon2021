//
//  ModuleExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class ModuleExpression:Expression
    {
    let module:Module
    
    init(module:Module)
        {
        self.module = module
        super.init()
        }
    }
