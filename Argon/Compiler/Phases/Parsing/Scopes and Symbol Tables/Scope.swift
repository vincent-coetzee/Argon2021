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
    var container:SymbolContainer { get set }
    func asSymbolContainer() -> SymbolContainer
    }
    
extension Scope
    {
    public func pushScope()
        {
        self.container = _currentScope.asSymbolContainer()
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
