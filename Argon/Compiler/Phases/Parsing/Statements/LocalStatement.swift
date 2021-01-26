//
//  LexicalStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LocalStatement:LetStatement
    {
    internal let localVariable:LocalVariable
    
    init(localVariable:LocalVariable)
        {
        self.localVariable = localVariable
        super.init(variable:localVariable)
        }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.localVariable.allocateAddresses(using:compiler)
        }
        
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
