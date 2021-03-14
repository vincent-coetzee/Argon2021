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
        try self.intermediateCodeGenerate(in:compiler.topModule!,codeHolder:.none,into: A3CodeBuffer(),using:compiler)
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(module:RootModule,using compiler:Compiler) throws
        {
        }
        
    private func intermediateCodeGenerate(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using compiler:Compiler) throws
        {
        for symbol in module.symbols.values
            {
            try symbol.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:compiler)
            }
        }
    }

