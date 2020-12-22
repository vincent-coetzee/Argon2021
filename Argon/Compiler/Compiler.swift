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
    public var module:Module?
//    private var path = ""
//    private var phase:CompilerPhase = Parser()
//    private var sourceTree = SourceFolder()
//
//    internal var sortedFilenames:[String]
//        {
//        return(sourceTree.children.map{$0.name}.sorted{$0<$1})
//        }
//
//    internal init(path:String) throws
//        {
//        self.path = path
//        let tree = SourceFolder(path: path)
//        if tree.isExpandable
//            {
//            self.sourceTree = tree
//            }
//        }
//
//    internal init()
//        {
//        self.path = ""
//        }
//
//    internal func sourceFiles() -> [SourceFile]
//        {
//        return(self.sourceTree.children)
//        }
//
//    internal func compile() throws
//        {
////        try self.sourceTree.compile(using: self)
//        }
//
//    internal func process() throws
//        {
//        var thePhase:CompilerPhase? = Parser()
//        while let phase = thePhase
//            {
//            try phase.process(using:self)
//            thePhase = phase.nextPhase
//            }
//        }
        
    internal func compile(source:String)
        {
        do
            {
            var currentPhase:CompilerPhase? = Parser()
            while let phase = currentPhase
                {
                try phase.process(source:source,using:self)
                currentPhase = phase.nextPhase
                }
            }
        catch let error as CompilerError
            {
            print("LINE: \(error.location) CODE: \(error.code)")
            let start = error.location.tokenStart
            let stop = error.location.tokenStop
            let text = source.substring(with:Range(uncheckedBounds: (lower:start,upper:stop)))
            print("ERROR IS: \(text)")
            }
        catch
            {
            print("Unknown error")
            }
        }
    }
