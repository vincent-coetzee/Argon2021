//
//  Compiler.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Compiler
    {
    public static let shared = Compiler()
    
    public var modules:Array<Module> = []
    
    public let staticSegment = StaticSegment(sizeInBytes:1024*1024*10)
    public let dataSegment = DataSegment(sizeInBytes:1024*1024*10)
    public let codeSegment = CodeSegment(sizeInBytes:1024*1024*10)
    public let stackSegment = StackSegment(sizeInBytes:1024*1024*10)
    public let managedSegment = ManagedSegment(sizeInBytes:1024*1024*10)
    
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
        
    public func segmentAtIdentifier(_ identifier:SegmentIdentifier) -> MemorySegment
        {
        if identifier == .stack
            {
            return(self.stackSegment)
            }
        else if identifier == .data
            {
            return(self.dataSegment)
            }
        else if identifier == .base
            {
            return(self.stackSegment)
            }
        else if identifier == .static
            {
            return(self.staticSegment)
            }
        else if identifier == .managed
            {
            return(self.managedSegment)
            }
        else if identifier == .code
            {
            return(self.codeSegment)
            }
        fatalError("Invalid segment")
        }
        
    internal func append(module:Module)
        {
        self.modules.append(module)
        }
        
    internal func compile(source:String)
        {
        do
            {
            var currentPhase:CompilerPhase? = Parser()
            while let phase = currentPhase
                {
                try phase.preProcess(source:source,using:self)
                try phase.process(source:source,using:self)
                try phase.postProcess(modules:self.modules,using:self)
                currentPhase = phase.nextPhase
                }
            }
        catch let error as CompilerError
            {
            print("LINE: \(error.location) CODE: \(error.code)")
            let start = error.location.tokenStart
            let stop = error.location.tokenStop
            let lineText = source.substring(with:Range(uncheckedBounds: (lower:error.location.lineStart,upper:error.location.lineStop)))
            print("LINE IS: \(lineText)")
            let text = source.substring(with:Range(uncheckedBounds: (lower:start,upper:stop)))
            print("ERROR IS: \(text)")
            print("HINT: \(error.hint)")
            }
        catch let systemError as SystemError
            {
            print("Error occurred \(systemError)")
            }
        catch
            {
            print("Unknown error")
            }
        }
    }
