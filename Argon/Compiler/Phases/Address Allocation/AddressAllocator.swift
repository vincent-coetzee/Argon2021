//
//  StorageAllocator.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class AddressAllocator:CompilerPhase
    {
    internal let name = "AddressAllocation"
    
    internal var nextPhase:CompilerPhase?
        {
        return(IntermediateCodeGenerator())
        }
        
    internal func process(source:String,using compiler:Compiler) throws
        {
        for module in compiler.modules
            {
            try self.allocateAddresses(in:module,using:compiler)
            }
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(modules:Array<Module>,using compiler:Compiler) throws
        {
        }
        
    private func allocateAddresses(in module:Module,using compiler:Compiler) throws
        {
        for symbol in module.symbols.values
            {
            try symbol.allocateAddresses(using:compiler)
            }
        }
    }
