//
//  SymbolContainer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/12.
//

import Foundation

public enum SymbolContainer
    {
    public var topSymbolTable:SymbolTable
        {
        
        }
        
    public var isNothing:Bool
        {
        switch(self)
            {
            case .nothing:
                return(true)
            default:
                return(false)
            }
        }
        
    case stackFrame(StackFrame)
    case `class`(Class)
    case module(Module)
    case topModule(TopModule)
    case methodInstance(MethodInstance)
    case nothing
    
    init(with coder:NSCoder)
        {
        let kind = coder.decodeInt64(forKey:"containerKind")
        switch(kind)
            {
            case(1):
                let aClass = coder.decodeObject(forKey:"containerClass") as! Class
                self = .class(aClass)
            case(2):
                let module = coder.decodeObject(forKey:"containerModule") as! Module
                self = .module(module)
            case(3):
                let module = coder.decodeObject(forKey:"containerModule") as! TopModule
                self = .topModule(module)
            case(4):
                let instance = coder.decodeObject(forKey:"containerMethodInstance") as! MethodInstance
                self = .methodInstance(instance)
            case(5):
                let frame = coder.decodeObject(forKey:"containerStackFrame") as! StackFrame
                self = .stackFrame(frame)
            case(6):
                self = .nothing
            default:
                fatalError("This should not happen")
            }
        }
        
    public func addClass(_ `class`:Class)
        {
        switch(self)
            {
            case .class:
                fatalError("A class can not be added to a class")
            case .stackFrame:
                fatalError("A class can not be added to a stack frame")
            case .module(let module):
                module.addClass(`class`)
            case .topModule(let module):
                module.addClass(`class`)
            case .methodInstance:
                fatalError("A class can not be added to a method instance")
            case .nothing:
                fatalError("A class can not be added to nothing")
            }
        }
        
    public func addConstant(_ constant:Constant)
        {
        switch(self)
            {
            case .class(let aClass):
                aClass.addConstant(constant)
            case .stackFrame(let frame):
                frame.addSymbol(constant)
            case .module(let module):
                module.addConstant(constant)
            case .topModule(let module):
                module.addConstant(constant)
            case .methodInstance:
                fatalError("A constant can not be added to a method instance")
            case .nothing:
                fatalError("A constant can not be added to nothing")
            }
        }
        
    public func addLocalVariable(_ variable:LocalVariable)
        {
        switch(self)
            {
            case .class:
                fatalError("A local variable can not be added to a class")
            case .stackFrame(let frame):
                frame.addSymbol(variable)
            case .module:
                fatalError("A local variable can not be added to a module")
            case .topModule:
                fatalError("A local variable can not be added to a topModule")
            case .methodInstance(let instance):
                instance.addLocalVariable(variable)
            case .nothing:
                fatalError("A local variable can not be added to nothing")
            }
        }
        
    public func addParameter(_ parameter:Parameter)
        {
        switch(self)
            {
            case .class:
                fatalError("A parameter can not be added to a class")
            case .stackFrame(let frame):
                frame.addSymbol(parameter)
            case .module:
                fatalError("A parameter can not be added to a module")
            case .topModule:
                fatalError("A parameter can not be added to a topModule")
            case .methodInstance:
                fatalError("A parameter should be added to a stack frame not a method instance")
            case .nothing:
                fatalError("A local variable can not be added to nothing")
            }
        }
        
    public func encode(with coder:NSCoder)
        {
        switch(self)
            {
            case .class(let aClass):
                coder.encode(1,forKey:"containerKind")
                coder.encode(aClass,forKey:"containerClass")
            case .stackFrame(let frame):
                coder.encode(5,forKey:"containerKind")
                coder.encode(frame,forKey:"containerStackFrame")
            case .module(let module):
                coder.encode(2,forKey:"containerKind")
                coder.encode(module,forKey:"containerModule")
            case .topModule(let module):
                coder.encode(3,forKey:"containerKind")
                coder.encode(module,forKey:"containerModule")
            case .methodInstance(let instance):
                coder.encode(4,forKey:"containerKind")
                coder.encode(instance,forKey:"containerMethodInstance")
            case .nothing:
                coder.encode(6,forKey:"containerKind")
            }
        }
        
    public var shortName:String
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.shortName)
            case .stackFrame(let frame):
                return("\(frame.id)")
            case .module(let module):
                return(module.shortName)
            case .topModule(let module):
                return(module.shortName)
            case .methodInstance(let instance):
                return(instance.shortName)
            case .nothing:
                fatalError("The chain of fullName should not have reached here")
            }
        }
        
    public var fullName:Name
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.fullName)
            case .stackFrame(let frame):
                return(Name("\(frame.id)"))
            case .module(let module):
                return(module.fullName)
            case .topModule(let module):
                return(module.fullName)
            case .methodInstance(let instance):
                return(instance.fullName)
            case .nothing:
                fatalError("The chain of fullName should not have reached here")
            }
        }
        
    public var topModule:TopModule
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.container.topModule)
            case .stackFrame(let frame):
                return(frame.container.topModule)
            case .module(let module):
                return(module.container.topModule)
            case .topModule(let module):
                return(module)
            case .methodInstance(let instance):
                return(instance.container.topModule)
            case .nothing:
                fatalError("The chain of topModule should not have reached here")
            }
        }
        
    public func lookup(shortName:String) -> SymbolSet
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.container.lookup(shortName:shortName))
            case .stackFrame(let frame):
                return(frame.container.lookup(shortName:shortName))
            case .module(let module):
                return(module.lookup(shortName:shortName))
            case .topModule(let module):
                return(module.lookup(shortName:shortName))
            case .methodInstance(let instance):
                return(instance.container.lookup(shortName:shortName))
            case .nothing:
                fatalError("The chain of topModule should not have reached here")
            }
        }
        
    public func lookup(name:Name) -> SymbolSet?
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.container.lookup(name:name))
            case .stackFrame(let frame):
                return(frame.container.lookup(name:name))
            case .module(let module):
                return(module.lookup(name:name))
            case .topModule(let module):
                return(module.lookup(name:name))
            case .methodInstance(let instance):
                return(instance.container.lookup(name:name))
            case .nothing:
                fatalError("The chain of topModule should not have reached here")
            }
        }
        
    public func lookupMethod(shortName:String) -> Method?
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.container.lookupMethod(shortName:shortName))
            case .stackFrame(let frame):
                return(frame.container.lookupMethod(shortName:shortName))
            case .module(let module):
                return(module.lookupMethod(shortName:shortName))
            case .topModule(let module):
                return(module.lookupMethod(shortName:shortName))
            case .methodInstance(let instance):
                return(instance.container.lookupMethod(shortName:shortName))
            case .nothing:
                fatalError("The chain of topModule should not have reached here")
            }
        }
    }
