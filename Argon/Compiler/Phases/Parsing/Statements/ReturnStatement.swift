//
//  ReturnStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ReturnStatement:ControlFlowStatement
    {
    internal override var isReturnStatement:Bool
        {
        return(true)
        }
        
    internal var value:Expression?
    
    init(location:SourceLocation = .zero,value:Expression)
        {
        self.value = value
        super.init(location:location)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.value?.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        try value?.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:using)
        }
    }
