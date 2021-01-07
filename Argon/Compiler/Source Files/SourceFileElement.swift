//
//  SourceFileElement.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/03.
//

import Foundation
import AppKit

public class SourceFileElement:SourceFile
    {
    internal enum ElementKind
        {
        case `class`(Class)
        case method(Method)
        case module(Module)
        case function(Function)
        case enumeration(Enumeration)
        case slot(Slot)
        case local(LocalVariable)
        
        var image:NSImage
            {
            switch(self)
                {
                case .class:
                    return(NSImage(named:"ClassIcon")!)
                case .module:
                    return(NSImage(named:"ModuleIcon")!)
                case .function:
                    return(NSImage(named:"FunctionIcon")!)
                case .enumeration:
                    return(NSImage(named:"EnumerationIcon")!)
                case .slot:
                    return(NSImage(named:"SlotIcon")!)
                case .local:
                    return(NSImage(named:"LocalIcon")!)
                case .method:
                    return(NSImage(named:"MethodIcon")!)
                }
            }

        
        var isFolder:Bool
            {
            switch(self)
                {
                case .class:
                    return(true)
                case .module:
                    return(true)
                case .function:
                    return(false)
                case .enumeration:
                    return(true)
                case .slot:
                    return(false)
                case .local:
                    return(false)
                case .method:
                    return(false)
                }
            }
            
        var shortName:String
            {
            switch(self)
                {
                case .class(let aClass):
                    return(aClass.shortName)
                case .module(let aClass):
                    return(aClass.shortName)
                case .function(let aClass):
                    return(aClass.shortName)
                case .method(let aClass):
                    return(aClass.shortName)
                case .slot(let aClass):
                    return(aClass.shortName)
                case .enumeration(let aClass):
                    return(aClass.shortName)
                case .local(let aClass):
                    return(aClass.shortName)
                }
            }
            
        var children:[SourceFileElement]
            {
            switch(self)
                {
                case .class(let aClass):
                    return(aClass.sourceFileElements())
                case .module(let aClass):
                    return(aClass.sourceFileElements())
                case .function(let aClass):
                    return(aClass.sourceFileElements())
                case .method(let aClass):
                    return(aClass.sourceFileElements())
                case .slot(let aClass):
                    return(aClass.sourceFileElements())
                case .enumeration(let aClass):
                    return(aClass.sourceFileElements())
                case .local(let aClass):
                    return(aClass.sourceFileElements())
                }
            }
        }
        
    private let kind:ElementKind
    
    init(_ kind:ElementKind)
        {
        self.kind = kind
        super.init()
        }
        
    public override var name: String
        {
        return(self.kind.shortName)
        }
    
    public override var isFolder:Bool
        {
        return(self.kind.isFolder)
        }
        
    public override var isFile:Bool
        {
        return(!self.isFolder)
        }
        
    public override var children:[SourceFile]
        {
        return(self.kind.children)
        }
    
    override var isExpandable: Bool
        {
        return(false)
        }
    }
