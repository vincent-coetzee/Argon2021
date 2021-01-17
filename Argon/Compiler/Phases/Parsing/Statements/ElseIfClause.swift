//
//  ElseIfClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ElseIfClause:ElseClause
    {
    private let condition:Expression

    init(location:SourceLocation = .zero,condition:Expression,block:Block)
        {
        self.condition = condition
        super.init(location:location,block:block)
        }
    }
