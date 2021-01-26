//
//  ClassExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class ClassExpression:Expression
    {
    let theClass:Class
    
    init(class:Class)
        {
        self.theClass = `class`
        super.init()
        }
    }
