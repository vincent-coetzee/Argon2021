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
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        if self.whenClauses.isEmpty
            {
            throw(CompilerError(error: .selectRequiresAtLeastOneWhenClause, location: self.location, hint: "select.whenClauses is empty"))
            }
        let exitLabel = A3Label.newLabel()
        let successLabel = A3Label.newLabel()
        var lastClause:SelectElementClause? = nil
        for clause in self.whenClauses
            {
            lastClause?.nextClause = clause
            lastClause = clause
            }
        if self.otherwiseClause != nil
            {
            lastClause?.nextClause = self.otherwiseClause
            }
        try expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let result = buffer.lastResult
        try self.whenClauses.first!.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using,subject:result,exitLabel:exitLabel,successLabel:successLabel)
        }
    }
