//
//  PeepholeCodeOptimiser.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class PeepholeCodeOptimiser:CompilerPhase
    {
    internal let name = "PeepholeCodeOptimisation"
    
    internal var nextPhase:CompilerPhase?
        {
        return(MachineCodeGenerator())
        }
        
    internal func process(source:String,using:Compiler) throws
        {
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(modules:Array<Module>,using compiler:Compiler) throws
        {
        }
    }
