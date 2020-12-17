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
        
    internal func process(using:Compiler) throws
        {
        }
    }
