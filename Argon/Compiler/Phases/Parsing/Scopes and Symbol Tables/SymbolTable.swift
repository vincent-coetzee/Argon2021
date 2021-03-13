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
    var container:SymbolContainer { get }
    func lookupClass(name:Name) -> Class?
    func lookupVariable(name:Name) -> Variable?
    func lookupMethod(name:Name) -> Method?
    func lookup(name:Name) -> SymbolSet?
    func addSymbol(_ symbol:Symbol)
    }
    
extension SymbolTable
    {
    public var topSymbolTable:SymbolTable
        {
        if self.container.isNothing
            {
            return(self)
            }
        return(self.container.topSymbolTable)
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
