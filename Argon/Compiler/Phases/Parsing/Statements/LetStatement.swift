//
//  LetStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LetStatement:Statement
    {
    private let variable:Variable
    
    init(location:SourceLocation = .zero,variable:Variable)
        {
        self.variable = variable
        super.init(location:location)
        }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.variable.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        if let expression = variable.initialValue
            {
            try expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
            }
        }
    }
