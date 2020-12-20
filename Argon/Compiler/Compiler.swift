//
//  Compiler.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class Compiler
    {
    private var path = ""
    private var phase:CompilerPhase = Parser()
    private var sourceTree = SourceFolder()

    internal var sortedFilenames:[String]
        {
        return(sourceTree.children.map{$0.name}.sorted{$0<$1})
        }
        
    internal init(path:String) throws
        {
        self.path = path
        let tree = SourceFolder(path: path)
        if tree.isExpandable
            {
            self.sourceTree = tree
            }
        }
        
    internal init()
        {
        self.path = ""
        }
        
    internal func sourceFiles() -> [SourceFile]
        {
        return(self.sourceTree.children)
        }
        
    internal func compile() throws
        {
//        try self.sourceTree.compile(using: self)
        }
        
    internal func process() throws
        {
        var thePhase:CompilerPhase? = Parser()
        while let phase = thePhase
            {
            try phase.process(using:self)
            thePhase = phase.nextPhase
            }
        }
        
    internal func compile(source:String) -> Module?
        {
        let parser = Parser()
        return(try? parser.parseModule(source:source))
        }
    }
