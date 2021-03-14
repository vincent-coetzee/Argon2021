//
//  ParseNode.swift
//  spark
//
//  Created by Vincent Coetzee on 09/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ParseNode:NSObject,SymbolTable
    {
    public var topSymbolTable: SymbolTable
        {
        fatalError("This should have been overridden")
        }
        
    public var container: SymbolContainer = .nothing
    
    internal var index:Int = Argon.nextIndex()

    
    public func addSymbol(_ symbol: Symbol)
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
    
    func addSymbol(_ symbol: Symbol,atName:Name) throws
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
        
    func addStatement(_ statement: Statement)
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
    
    public func lookup(shortName: String) -> SymbolSet?
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
        
    public func lookup(name: Name) -> SymbolSet?
        {
        fatalError("This method \(#function) should have been overridden in a subclass - it's not defined for a \(Swift.type(of:self))")
        }
        
    func lookupMethod(shortName: String) -> Method?
        {
        fatalError("This method \(#function) should have been overridden in a subclass I am \(Swift.type(of:self))")
        }
    }
