//
//  ParseNode.swift
//  spark
//
//  Created by Vincent Coetzee on 09/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ParseNode:Scope
    {
    internal var parentScope:Scope?
    internal var index:Int = Argon.nextIndex()
    
    func pushScope()
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
    
    func popScope()
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
    
    func addSymbol(_ symbol: Symbol)
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
    
    func addStatement(_ statement: Statement)
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
    
    func lookup(shortName: String) -> SymbolSet?
        {
        fatalError("This method \(#function) should have been overridden in a subclass")
        }
//        
//    internal required init()
//        {
//        }
    }
