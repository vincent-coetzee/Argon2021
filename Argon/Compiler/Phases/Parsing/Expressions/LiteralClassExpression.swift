//
//  LiteralClassExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralClassExpression:LiteralExpression
    {
    let _class:Class
    
    init(class:Class)
        {
        self._class = `class`
        super.init()
        }
    }
