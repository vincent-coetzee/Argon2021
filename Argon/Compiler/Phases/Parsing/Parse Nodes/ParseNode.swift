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
    
    public let id:UUID

    public override init()
        {
        self.id = UUID()
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.id,forKey:"id")
        }
        
    public required init?(coder: NSCoder)
        {
        self.id = coder.decodeObject(forKey:"id") as! UUID
        }
        
    public func addLocalVariable(_ local:LocalVariable)
        {
        fatalError("This method \(#function) should have been overridden in a subclass but in class \(Swift.type(of:self)) was not")
        }
        
    public func addTypeSymbol(_ local:TypeSymbol)
        {
        fatalError("This method \(#function) should have been overridden in a subclass but in class \(Swift.type(of:self)) was not")
        }
        
    public func addSymbol(_ symbol: Symbol)
        {
        fatalError("This method \(#function) should have been overridden in a subclass but in class \(Swift.type(of:self)) was not")
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
        
    public func removeSymbol(_ symbol:Symbol)
        {
        fatalError("This method \(#function) should have been overridden in a subclass I am \(Swift.type(of:self))")
        }
    }
