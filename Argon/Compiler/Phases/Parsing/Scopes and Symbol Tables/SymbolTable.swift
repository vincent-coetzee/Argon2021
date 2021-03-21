//
//  SymbolTable.swift
//  spark
//
//  Created by Vincent Coetzee on 22/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public protocol SymbolTable
    {
    func lookupModule(name:Name) -> Module?
    func lookupClass(name:Name) -> Class?
    func lookupVariable(name:Name) -> Variable?
    func lookupMethod(name:Name) -> Method?
    func lookup(name:Name) -> SymbolSet?
    func lookup(shortName:String) -> SymbolSet?
    func addSymbol(_ symbol:Symbol)
    func addLocalVariable(_ variable:LocalVariable)
    func addTypeSymbol(_ symbol:TypeSymbol)
    func removeSymbol(_ symbol:Symbol)
    }
    
extension SymbolTable
    {
    public func lookupModule(name:Name) -> Module?
        {
        if let set = self.lookup(name:name)
            {
            return(set.module)
            }
        return(nil)
        }
        
    public func lookupClass(name:Name) -> Class?
        {
        if let set = self.lookup(name:name)
            {
            return(set.class)
            }
        return(nil)
        }
        
    public func lookupMethod(name:Name) -> Method?
        {
        if let set = self.lookup(name:name)
            {
            return(set.method)
            }
        return(nil)
        }
        
    public func lookupVariable(name:Name) -> Variable?
        {
        if let set = self.lookup(name:name)
            {
            return(set.variable)
            }
        return(nil)
        }
    }
