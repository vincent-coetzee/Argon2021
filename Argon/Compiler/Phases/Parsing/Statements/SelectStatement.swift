//
//  SelectStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class SelectStatement:Statement
    {
    private let expression:Expression
    internal var whenClauses = WhenClauses()
    internal var otherwiseClause:OtherwiseClause?
    
    init(location:SourceLocation = .zero,expression:Expression)
        {
        self.expression = expression
        super.init(location:location)
        }
        
    override func lookup(shortName: String) -> SymbolSet?
        {
        return(self.parentScope?.lookup(shortName:shortName))
        }
    }
