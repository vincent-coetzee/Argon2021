//
//  AliasStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class AliasStatement:Statement
    {
    private let alias:TypeSymbol
    
    init(alias:TypeSymbol)
        {
        self.alias = alias
        super.init()
        }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func typeCheck() throws
        {
        throw(CompilerError(.notImplemented("AliasStatement>>typeCheck"),.zero))
        }
    }
