//
//  Scope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

fileprivate var scopeStack = Stack<Scope>()
fileprivate var currentScope:Scope =
    {
    Module.argonModule.initArgonModule()
    return(Module.rootModule)
    }()

internal protocol Scope:class,SymbolTable,StatementBlock
    {
    var parentScope:Scope? { get set }
    var index:Int { get }
    func pushScope()
    func popScope()
    func localScope() -> Scope
    }
    
extension Scope
    {
    public static func ==(lhs:Scope,rhs:Scope) -> Bool
        {
        return(lhs.index == rhs.index)
        }
        
    internal func push()
        {
        self.parentScope = currentScope
        scopeStack.push(currentScope)
        currentScope = self
        }
        
    internal func pop()
        {
        currentScope = scopeStack.pop()
        }
        
    internal func localScope() -> Scope
        {
        let scope = LocalScope()
        return(scope)
        }
    }

extension Module
    {
    internal static var innerScope:Scope
        {
        return(currentScope)
        }
    }
