//
//  MachineCodeGenerator.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class MachineCodeGenerator:CompilerPhase
    {
    internal let name = "MachineCodeGeneration"
    
    internal var nextPhase:CompilerPhase?
        {
        return(ObjectFileGenerator())
        }
        
    internal func process(source:String,using:Compiler) throws
        {
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(module:TopModule,using compiler:Compiler) throws
        {
        }
    }
