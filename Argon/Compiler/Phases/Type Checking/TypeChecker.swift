//
//  TypeChecker.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class TypeChecker:CompilerPhase
    {
    internal let name = "TypeChecking"
    
    internal var nextPhase:CompilerPhase?
        {
        return(AddressAllocator())
        }
        
    internal func process(source:String,using compiler:Compiler) throws
        {
        try self.typeCheck(compiler.topModule!)
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(module:RootModule,using compiler:Compiler) throws
        {
        }
        
    private func typeCheck(_ module:Module) throws
        {
        }
    }
