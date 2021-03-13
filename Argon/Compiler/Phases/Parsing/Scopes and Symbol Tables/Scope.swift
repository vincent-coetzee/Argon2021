//
//  Scope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

fileprivate var scopeStack = Stack<Scope>()
fileprivate var currentGlobalScope:Scope =
    {
    Module.argonModule.initArgonModule()
    return(Module.rootModule)
    }()
    
fileprivate var rulingModule:Module = Module.rootModule

public protocol Scope:class
    {
    var container:SymbolContainer { get set }
    func asSymbolContainer() -> SymbolContainer
    func lookupSlot(name:Name) -> Slot?
    func lookupVariable(name:Name) -> Variable? // Constant, LocalVariable or Parameter
    func lookupClass(name:Name) -> Class?
    func lookupMethod(name:Name) -> Method?
    func addSymbol(_ symbol:Symbol)
    func pushScope()
    func popScope()
    }
    
extension Scope
    {
    public func pushScope()
        {
        self.container = self.asSymbolContainer()
        scopeStack.push(currentGlobalScope)
        currentGlobalScope = self
        if currentGlobalScope is Module
            {
            rulingModule = currentGlobalScope as! Module
            }
        }
        
    public func popScope()
        {
        currentGlobalScope = scopeStack.popScope()
        if currentGlobalScope is Module
            {
            rulingModule = currentGlobalScope as! Module
            }
        }
    }

extension Module
    {
    public static var currentModule:Module
        {
        return(rulingModule)
        }
        
    public static var currentScope:Scope
        {
        return(currentGlobalScope)
        }
    }
