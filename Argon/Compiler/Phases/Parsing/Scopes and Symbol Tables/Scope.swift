//
//  Scope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

fileprivate var scopeStack = Stack<Scope>()
fileprivate var currentScope:Scope = Module.rootModule.initRootModule()

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
        
    internal func lookup(name:Name) -> SymbolSet?
        {
        if name.count == 0
            {
            return(SymbolSet(self as! Symbol))
            }
        if name.count == 1
            {
            return(self.lookup(shortName: name.first))
            }
        return((self.lookup(shortName: name.first) as? Scope)?.lookup(name: name.withoutFirst()))
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
