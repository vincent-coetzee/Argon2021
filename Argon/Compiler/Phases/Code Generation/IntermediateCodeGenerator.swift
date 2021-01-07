//
//  IntermediateCodeGenerator.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class IntermediateCodeGenerator:CompilerPhase
    {
    internal let name = "IntermediateCodeGenerator"
    
    internal var nextPhase:CompilerPhase?
        {
        return(CodeOptimiser())
        }
        
    internal func process(source:String,using compiler:Compiler) throws
        {
        for module in compiler.modules
            {
            try self.intermediateCodeGenerate(in:module,codeHolder:.none,into: ThreeAddressInstructionBuffer(),using:compiler)
            }
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(modules:Array<Module>,using compiler:Compiler) throws
        {
        }
        
    private func intermediateCodeGenerate(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using compiler:Compiler) throws
        {
        for symbol in module.symbols.values
            {
            try symbol.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:compiler)
            }
        }
    }

