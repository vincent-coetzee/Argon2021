//
//  Scope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

fileprivate var scopeStack = Stack<Scope>()

fileprivate var _currentScope:Scope =
    {
    Module.argonModule.initArgonModule()
    return(Module.rootModule)
    }()
    
fileprivate var _currentModule:Module = Module.rootModule

public protocol Scope:class,SymbolTable
    {
    var id:UUID { get }
    static func equals(lhs:Scope,rhs:Scope) -> Bool
    var container:SymbolContainer { get set }
    func asSymbolContainer() -> SymbolContainer
    }
    
extension Scope
    {
    public static func equals(lhs:Scope,rhs:Scope) -> Bool
        {
        if lhs is Symbol && rhs is Symbol
            {
            return((lhs as! Symbol) == (rhs as! Symbol))
            }
        if lhs is Block && rhs is Block
            {
            return((lhs as! Block) == (rhs as! Block))
            }
        if lhs is StackFrame && rhs is StackFrame
            {
            return((lhs as! StackFrame) == (rhs as! StackFrame))
            }
        if lhs is Module && rhs is Module
            {
            return((lhs as! Module) == (rhs as! Module))
            }
        if lhs is MethodInstance && rhs is MethodInstance
            {
            return((lhs as! MethodInstance) == (rhs as! MethodInstance))
            }
        fatalError("You missed one")
        }
        
    public func pushScope()
        {
        if self.container == .nothing && _currentScope.id != self.id
            {
            self.container = _currentScope.asSymbolContainer()
            }
        scopeStack.push(_currentScope)
        _currentScope = self
        if _currentScope is Module
            {
            _currentModule = _currentScope as! Module
            }
        }
        
    public func popScope()
        {
        _currentScope = scopeStack.pop()
        if _currentScope is Module
            {
            _currentModule = _currentScope as! Module
            }
        }
        
    public static var currentScope:Scope
        {
        return(_currentScope)
        }
        
    public static var currentModule:Module
        {
        return(_currentModule)
        }
    }

extension Symbol
    {
    public static var currentModule:Module
        {
        return(_currentModule)
        }
        
    public static var currentScope:Scope
        {
        return(_currentScope)
        }
    }
