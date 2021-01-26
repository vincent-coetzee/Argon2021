//
//  SelectElementClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class SelectElementClause:Clause
    {
    public let testClauseLabel = A3Label()
    public var nextClause:SelectElementClause?
    internal var block = Block()
    
    func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler,subject:A3Address,exitLabel:A3Label,successLabel:A3Label) throws
        {
        }
    }
