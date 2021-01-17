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
    
    init(location:SourceLocation = .zero,expression:Expression,block:Block)
        {
        self.expression = expression
        self.block = block
        super.init(location:location)
        }
    }

typealias WhenClauses = Array<WhenClause>
