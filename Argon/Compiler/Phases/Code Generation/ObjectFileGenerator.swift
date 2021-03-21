//
//  ObjectFileGenerator.swift
//  Argon
//
//  Created by Vincent Coetzee on 02/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ObjectFileGenerator:CompilerPhase
    {
    internal let name = "ObjectFileGeneration"
    internal let objectFileDirectoryPath = "/Users/vincent/Desktop"
    
    internal var nextPhase:CompilerPhase?
        {
        return(nil as CompilerPhase?)
        }
        
    internal func process(source:String,using:Compiler) throws
        {
        }
        
    internal func preProcess(source:String,using compiler:Compiler) throws
        {
        }
        
    internal func postProcess(module:Module,using compiler:Compiler) throws
        {
        }
    }
