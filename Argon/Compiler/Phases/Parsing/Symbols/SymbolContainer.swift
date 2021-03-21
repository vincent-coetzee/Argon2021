//
//  SymbolContainer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/12.
//

import Foundation

public enum SymbolContainer:Equatable
    {
    public static func == (lhs: SymbolContainer, rhs: SymbolContainer) -> Bool
        {
        switch(lhs,rhs)
            {
            case (.stackFrame(let frame1),.stackFrame(let frame2)):
                return(frame1.id == frame2.id)
            case (.class(let frame1),.class(let frame2)):
                return(frame1.id == frame2.id)
            case (.module(let frame1),.module(let frame2)):
                return(frame1.id == frame2.id)
            case (.rootModule(let frame1),.rootModule(let frame2)):
                return(frame1.id == frame2.id)
            case (.methodInstance(let frame1),.methodInstance(let frame2)):
                return(frame1.id == frame2.id)
            case (.block(let frame1),.block(let frame2)):
                return(frame1.id == frame2.id)
            case (.slot(let frame1),.slot(let frame2)):
                return(frame1.id == frame2.id)
            case (.closure(let frame1),.closure(let frame2)):
                return(frame1.id == frame2.id)
            case (.nothing,.nothing):
                return(true)
            default:
                return(false)
            }
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
    case rootModule(RootModule)
    case methodInstance(MethodInstance)
    case block(Block)
    case slot(Slot)
    case closure(Closure)
    case nothing
    
    init(with coder:NSCoder)
        {
        let kind = coder.decodeInt64(forKey:"containerKind")
        switch(kind)
            {
            case(0):
                self = .nothing
            case(1):
                let aClass = coder.decodeObject(forKey:"containerClass") as! Class
                self = .class(aClass)
            case(2):
                let module = coder.decodeObject(forKey:"containerModule") as! Module
                self = .module(module)
            case(3):
                let module = coder.decodeObject(forKey:"containerModule") as! RootModule
                self = .rootModule(module)
            case(4):
                let instance = coder.decodeObject(forKey:"containerMethodInstance") as! MethodInstance
                self = .methodInstance(instance)
            case(5):
                let frame = coder.decodeObject(forKey:"containerStackFrame") as! StackFrame
                self = .stackFrame(frame)
            case(6):
                let block = coder.decodeObject(forKey:"containerBlock") as! Block
                self = .block(block)
            case(7):
                let slot = coder.decodeObject(forKey:"containerSlot") as! Slot
                self = .slot(slot)
            case(8):
                let closure = coder.decodeObject(forKey:"containerClosure") as! Closure
                self = .closure(closure)
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
            case .closure:
                fatalError("A closue can not be added to a class")
            case .slot:
                fatalError("A class can not be added to a slot")
            case .block:
                fatalError("A class can not be added to a block")
            case .stackFrame:
                fatalError("A class can not be added to a stack frame")
            case .module(let module):
                module.addClass(`class`)
            case .rootModule(let module):
                module.addClass(`class`)
            case .methodInstance:
                fatalError("A class can not be added to a method instance")
            case .nothing:
                fatalError("A class can not be added to nothing")
            }
        }
        
    public func replaceSlot(_ slot:Slot)
        {
        switch(self)
            {
            case .block:
                fatalError("Blocks can not have slots")
            case .closure:
                fatalError("Closures can not have slots")
            case .class(let aClass):
                aClass.replaceSlot(slot)
            case .stackFrame:
                fatalError("Stack frames can not have slots")
            case .module(let module):
                module.replaceSlot(slot)
            case .rootModule(let module):
                module.replaceSlot(slot)
            case .slot:
                fatalError("Slots can not have slots")
            case .methodInstance:
                fatalError("Method instances can not have slots")
            case .nothing:
                fatalError("Nothing can not have slots")
            }
        }
        
    public func replaceConstant(_ slot:Constant)
        {
        switch(self)
            {
            case .block(let block):
                block.replaceConstant(slot)
            case .closure(let closure):
                closure.replaceConstant(slot)
            case .class(let aClass):
                aClass.replaceConstant(slot)
            case .stackFrame:
                fatalError("Stack frames can not have slots")
            case .module(let module):
                module.replaceConstant(slot)
            case .rootModule(let module):
                module.replaceConstant(slot)
            case .slot:
                fatalError("Slots can not have slots")
            case .methodInstance:
                fatalError("Method instances can not have slots")
            case .nothing:
                fatalError("Nothing can not have slots")
            }
        }
        
    public func addConstant(_ constant:Constant)
        {
        switch(self)
            {
            case .block(let block):
                block.addSymbol(constant)
            case .closure(let closure):
                closure.addConstant(constant)
            case .class(let aClass):
                aClass.addConstant(constant)
            case .stackFrame(let frame):
                frame.addSymbol(constant)
            case .module(let module):
                module.addConstant(constant)
            case .rootModule(let module):
                module.addConstant(constant)
            case .slot:
                fatalError("A constant can not be added to a slot")
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
            case .slot:
                fatalError("A local variable can not be added to a slot")
            case .closure(let closure):
                closure.addLocalVariable(variable)
            case .block(let block):
                block.addSymbol(variable)
            case .class:
                fatalError("A local variable can not be added to a class")
            case .stackFrame(let frame):
                frame.addSymbol(variable)
            case .module:
                fatalError("A local variable can not be added to a module")
            case .rootModule:
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
            case .slot:
                fatalError("A parameter can not be added to a slot")
            case .block(let block):
                block.addSymbol(parameter)
            case .closure(let block):
                block.addParameter(parameter)
            case .class:
                fatalError("A parameter can not be added to a class")
            case .stackFrame(let frame):
                frame.addSymbol(parameter)
            case .module:
                fatalError("A parameter can not be added to a module")
            case .rootModule:
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
            case .nothing:
                coder.encode(0,forKey:"containerKind")
            case .block(let block):
                coder.encode(6,forKey:"containerKind")
                coder.encode(block,forKey:"containerBlock")
            case .slot(let slot):
                coder.encode(7,forKey:"containerKind")
                coder.encode(slot,forKey:"containerSlot")
            case .class(let aClass):
                coder.encode(1,forKey:"containerKind")
                coder.encode(aClass,forKey:"containerClass")
            case .stackFrame(let frame):
                coder.encode(5,forKey:"containerKind")
                coder.encode(frame,forKey:"containerStackFrame")
            case .module(let module):
                coder.encode(2,forKey:"containerKind")
                coder.encode(module,forKey:"containerModule")
            case .rootModule(let module):
                coder.encode(3,forKey:"containerKind")
                coder.encode(module,forKey:"containerModule")
            case .methodInstance(let instance):
                coder.encode(4,forKey:"containerKind")
                coder.encode(instance,forKey:"containerMethodInstance")
            case .closure(let closure):
                coder.encode(8,forKey:"containerKind")
                coder.encode(closure,forKey:"containerClosure")
            }
        }
        
    public func pushScope()
        {
        switch(self)
            {
            case .block(let block):
                block.pushScope()
            case .closure(let closure):
                closure.pushScope()
            case .slot(let slot):
                slot.pushScope()
            case .class(let aClass):
                aClass.pushScope()
            case .stackFrame(let frame):
                frame.pushScope()
            case .module(let module):
                module.pushScope()
            case .rootModule(let module):
                module.pushScope()
            case .methodInstance(let instance):
                instance.pushScope()
            case .nothing:
                fatalError("pushScope can not be called on a container of nothing")
            }
        }
        
    public func popScope()
        {
        switch(self)
            {
            case .block(let block):
                block.popScope()
            case .closure(let closure):
                closure.popScope()
            case .slot(let slot):
                slot.popScope()
            case .class(let aClass):
                aClass.popScope()
            case .stackFrame(let frame):
                frame.popScope()
            case .module(let module):
                module.popScope()
            case .rootModule(let module):
                module.popScope()
            case .methodInstance(let instance):
                instance.popScope()
            case .nothing:
                fatalError("popScope can not be called on a container of nothing")
            }
        }
        
    public var shortName:String
        {
        switch(self)
            {
            case .block:
                fatalError("The chain of shortName should not have reached here")
            case .class(let aClass):
                return(aClass.shortName)
            case .closure(let closure):
                return(closure.shortName)
            case .slot(let slot):
                return(slot.shortName)
            case .stackFrame(let frame):
                return("\(frame.id)")
            case .module(let module):
                return(module.shortName)
            case .rootModule(let module):
                return(module.shortName)
            case .methodInstance(let instance):
                return(instance.shortName)
            case .nothing:
                fatalError("The chain of shortName should not have reached here")
            }
        }
        
    public var id:UUID
        {
        switch(self)
            {
            case .block(let block):
                return(block.id)
            case .closure(let closure):
                return(closure.id)
            case .class(let aClass):
                return(aClass.id)
            case .slot(let slot):
                return(slot.id)
            case .stackFrame(let frame):
                return(frame.id)
            case .module(let module):
                return(module.id)
            case .rootModule(let module):
                return(module.id)
            case .methodInstance(let instance):
                return(instance.id)
            case .nothing:
                return(UUID())
            }
        }
        
    public var fullName:Name
        {
        switch(self)
            {
            case .block(let block):
                return(block.container.fullName)
            case .closure(let closure):
                return(closure.container.fullName)
            case .slot(let slot):
                return(slot.fullName)
            case .class(let aClass):
                return(aClass.fullName)
            case .stackFrame(let frame):
                return(Name("\(frame.id)"))
            case .module(let module):
                return(module.fullName)
            case .rootModule(let module):
                return(module.fullName)
            case .methodInstance(let instance):
                return(instance.fullName)
            case .nothing:
                return(Name.anchor)
            }
        }
        
    public var rootModule:RootModule
        {
        switch(self)
            {
            case .block(let block):
                return(block.container.rootModule)
            case .closure(let closure):
                return(closure.container.rootModule)
            case .slot(let slot):
                return(slot.container.rootModule)
            case .class(let aClass):
                return(aClass.container.rootModule)
            case .stackFrame(let frame):
                return(frame.container.rootModule)
            case .module(let module):
                return(module.container.rootModule)
            case .rootModule(let module):
                return(module)
            case .methodInstance(let instance):
                return(instance.container.rootModule)
            case .nothing:
                fatalError("The chain of topModule should not have reached here")
            }
        }
        
        
    public var rootSymbol:Symbol
        {
        switch(self)
            {
            case .block(let block):
                return(block.rootSymbol)
            case .closure(let closure):
                return(closure.container.rootSymbol)
            case .slot(let slot):
                return(slot.container.rootSymbol)
            case .class(let aClass):
                return(aClass.rootSymbol)
            case .stackFrame(let frame):
                return(frame.rootSymbol)
            case .module(let module):
                return(module.rootSymbol)
            case .rootModule(let module):
                return(module.rootSymbol)
            case .methodInstance(let instance):
                return(instance.rootSymbol)
            case .nothing:
                fatalError("The chain of topSymbolTable should not have reached here")
            }
        }
        
        
    public func lookup(shortName:String) -> SymbolSet?
        {
        switch(self)
            {
            case .block(let block):
                return(block.lookup(shortName:shortName))
            case .closure(let closure):
                return(closure.lookup(shortName:shortName))
            case .slot(let slot):
                return(slot.container.lookup(shortName:shortName))
            case .class(let aClass):
                return(aClass.container.lookup(shortName:shortName))
            case .stackFrame(let frame):
                return(frame.container.lookup(shortName:shortName))
            case .module(let module):
                return(module.lookup(shortName:shortName))
            case .rootModule(let module):
                return(module.lookup(shortName:shortName))
            case .methodInstance(let instance):
                return(instance.container.lookup(shortName:shortName))
            case .nothing:
                return(nil)
            }
        }
        
    public func lookup(name:Name) -> SymbolSet?
        {
        switch(self)
            {
            case .block(let block):
                return(block.lookup(name:name))
            case .closure(let closure):
                return(closure.lookup(name:name))
            case .slot(let slot):
                return(slot.container.lookup(name:name))
            case .class(let aClass):
                return(aClass.container.lookup(name:name))
            case .stackFrame(let frame):
                return(frame.container.lookup(name:name))
            case .module(let module):
                return(module.lookup(name:name))
            case .rootModule(let module):
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
            case .block(let block):
                return(block.container.lookupMethod(shortName:shortName))
            case .closure(let closure):
                return(closure.container.lookupMethod(shortName:shortName))
            case .slot(let slot):
                return(slot.container.lookupMethod(shortName:shortName))
            case .class(let aClass):
                return(aClass.container.lookupMethod(shortName:shortName))
            case .stackFrame(let frame):
                return(frame.container.lookupMethod(shortName:shortName))
            case .module(let module):
                return(module.lookupMethod(shortName:shortName))
            case .rootModule(let module):
                return(module.lookupMethod(shortName:shortName))
            case .methodInstance(let instance):
                return(instance.container.lookupMethod(shortName:shortName))
            case .nothing:
                fatalError("The chain of topModule should not have reached here")
            }
        }
    }
