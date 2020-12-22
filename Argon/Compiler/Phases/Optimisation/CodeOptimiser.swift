//
//  CodeOptimiser.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class CodeOptimiser:CompilerPhase
    {
    internal let name = "CodeOptimisation"
    
    internal var nextPhase:CompilerPhase?
        {
        return(PeepholeCodeOptimiser())
        }
        
    internal func process(source:String,using:Compiler) throws
        {
        }
    }
