//
//  WhenClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class WhenClause:Clause
    {
    private let expression:Expression
    private let block:Block
    
    init(expression:Expression,block:Block)
        {
        self.expression = expression
        self.block = block
        super.init()
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }

typealias WhenClauses = Array<WhenClause>
