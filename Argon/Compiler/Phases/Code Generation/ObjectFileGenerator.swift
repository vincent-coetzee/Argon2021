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
        
    internal func postProcess(modules:Array<Module>,using compiler:Compiler) throws
        {
        for module in modules
            {
            try self.writeObjectFile(for:module,using:compiler)
            }
        }
        
    private func writeObjectFile(for module:Module,using:Compiler) throws
        {
        
        let path = self.objectFileDirectoryPath + "/" + module.shortName + ".argonm"
        module.dump()
        let file = try ObjectFile(path: path, mode: "wt")
        try file.open()
        try file.initializeForWriting()
        try file.write(module)
        try file.close()
        }
    }
