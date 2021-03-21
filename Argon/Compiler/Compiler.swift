//
//  Compiler.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa

public class Compiler
    {
    private static let ArgonDirectory = NSHomeDirectory() + "/Argon"
    private static let ArgonRepositoryDirectory = Compiler.ArgonDirectory + "/Repository"
    
    public var hasIssues:Bool
        {
        return(!self.issues.isEmpty)
        }
        
    public var module:Module?
    public var issues = Array<CompilerIssue>()
    
    public let staticSegment = StaticSegment(sizeInBytes:1024*1024*10)
    public let dataSegment = DataSegment(sizeInBytes:1024*1024*10)
    public let codeSegment = CodeSegment(sizeInBytes:1024*1024*10)
    public let stackSegment = StackSegment(sizeInBytes:1024*1024*10)
    public let managedSegment = ManagedSegment(sizeInBytes:1024*1024*10)
    
    public init() throws
        {
        try self.makeArgonDirectoriesIfNeeded()
        }
        
    private func makeArgonDirectoriesIfNeeded() throws
        {
        let manager = FileManager.default
        var isDirectory:ObjCBool = false
        if manager.fileExists(atPath: Self.ArgonDirectory, isDirectory: &isDirectory)
            {
            if !isDirectory.boolValue
                {
                throw(CompilerError(.argonDirectoryIsNotValid))
                }
            }
        else
            {
            try manager.createDirectory(atPath: Self.ArgonDirectory, withIntermediateDirectories: true, attributes: [:])
            }
        if !manager.fileExists(atPath: Self.ArgonDirectory, isDirectory: nil)
            {
            throw(CompilerError(.creationOfArgonDirectoryFailed))
            }
        if manager.fileExists(atPath: Self.ArgonRepositoryDirectory, isDirectory: &isDirectory)
            {
            if !isDirectory.boolValue
                {
                throw(CompilerError(.argonRepositoryDirectoryIsNotValid))
                }
            }
        else
            {
            try manager.createDirectory(atPath: Self.ArgonRepositoryDirectory, withIntermediateDirectories: true, attributes: [:])
            }
        if !manager.fileExists(atPath: Self.ArgonRepositoryDirectory, isDirectory: nil)
            {
            throw(CompilerError(.creationOfArgonRepositoryDirectoryFailed))
            }
        }
        
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
        
    internal func writeSymbols(forModule module:Module) -> Result<Module,CompilerError>
        {
        let module = self.module!
        let path = Self.ArgonRepositoryDirectory + "/" + module.shortName + ".arm"
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: (module as Any), requiringSecureCoding: false)
            {
            let url = URL(fileURLWithPath: path)
            if (try? data.write(to: url)) != nil
                {
                return(Result.success(module))
                }
            }
        return(Result.failure(CompilerError(.unableToWriteTo(path))))
        }
        
    internal func compile(source:String) -> Result<Module,CompilerError>
        {
        do
            {
            var currentPhase:CompilerPhase? = Parser()
            while let phase = currentPhase
                {
                try phase.preProcess(source:source,using:self)
                try phase.process(source:source,using:self)
                try phase.postProcess(module:self.module!,using:self)
                currentPhase = phase.nextPhase
                }
            module?.source = source
            return(Result.success(self.module!))
            }
        catch let error as CompilerError
            {
            return(Result.failure(error))
            }
        catch let error
            {
            return(Result.failure(CompilerError(error)))
            }
        }
    }
