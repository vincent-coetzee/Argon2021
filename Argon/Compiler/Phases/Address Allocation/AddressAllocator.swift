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
        
    internal func process(using:Compiler) throws
        {
        }
    }
