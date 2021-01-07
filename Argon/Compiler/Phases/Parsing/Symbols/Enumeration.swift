//
//  Enumeration.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Enumeration:SymbolContainer
    {
    private var cases:[EnumerationCase] = []
    private var _class:Class
    
    internal var baseClass:Class
        {
        return(_class)
        }
        
    internal override var isModuleLevelSymbol:Bool
        {
        return(true)
        }

    internal override var typeClass:Class
        {
        return(self._class)
        }
        
    internal init(shortName:String,class:Class)
        {
        self._class = `class`
        super.init(shortName: shortName)
        }
    
    required init()
        {
        self._class = .voidClass
        super.init()
        }
    
    func addCase(_ enumCase:EnumerationCase)
        {
        self.cases.append(enumCase)
        }
        
    func hasCase(named:String) -> Bool
        {
        for aCase in self.cases
            {
            if aCase.shortName == named
                {
                return(true)
                }
            }
        return(false)
        }
        
    func enumerationCase(named:String) -> EnumerationCase?
        {
        for aCase in self.cases
            {
            if aCase.shortName == named
                {
                return(aCase)
                }
            }
        return(nil as EnumerationCase?)
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        for aCase in self.cases
            {
            if aCase.shortName == shortName
                {
                return(SymbolSet(aCase))
                }
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
        
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
    }

public class EnumerationCase:Symbol
    {
    let symbol:Argon.Symbol
    let associatedTypes:Classes
    let value:Expression?
    
    init(shortName:String,symbol:Argon.Symbol,associatedTypes:Classes,value:Expression?)
        {
        self.symbol = symbol
        self.associatedTypes = associatedTypes
        self.value = value
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
