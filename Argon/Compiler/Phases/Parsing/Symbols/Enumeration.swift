//
//  Enumeration.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa

public class Enumeration:Class
    {
    internal static let conduitSinkEnumeration = Enumeration(shortName:"ConduitSink",class:.uIntegerClass).case("#none",value:0).case("#memory",value:1).case("#socket",value:2).case("#file",value:3)
    
    internal var cases:[EnumerationCase] = []
    private var _class:Class
    
    internal var baseClass:Class
        {
        return(_class)
        }
        
    internal override var isModuleLevelSymbol:Bool
        {
        return(true)
        }

    public override var image:NSImage
        {
        return(NSImage(named:"IconEnumeration64")!)
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
        super.init(shortName:"")
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
   public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptEnumeration(self)
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
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        for aCase in self.cases
            {
            try aCase.allocateAddresses(using:compiler)
            }
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
        
    internal func `case`(_ symbol:Argon.Symbol,associatedTypes:Classes = [],value:Expression?  = nil) -> Enumeration
        {
        let aCase = EnumerationCase(shortName: symbol, symbol: symbol, associatedTypes:associatedTypes, value: value)
        self.addCase(aCase)
        return(self)
        }
        
    internal func `case`(_ symbol:Argon.Symbol,associatedTypes:Classes = [],value:Int) -> Enumeration
        {
        let aCase = EnumerationCase(shortName: symbol, symbol: symbol, associatedTypes:associatedTypes, value: LiteralIntegerExpression(integer:Argon.Integer(value)))
        self.addCase(aCase)
        return(self)
        }
    }

public class EnumerationCase:Symbol
    {
    let symbol:Argon.Symbol
    let associatedTypes:Classes
    let value:Expression?
    
    init(shortName:String,symbol:Argon.Symbol,associatedTypes:Classes = [],value:Expression?  = nil)
        {
        self.symbol = symbol
        self.associatedTypes = associatedTypes
        self.value = value
        super.init(shortName:shortName)
        }
    
    init(symbol:Argon.Symbol,associatedTypes:Classes = [],value:Expression?  = nil)
        {
        self.symbol = symbol
        self.associatedTypes = associatedTypes
        self.value = value
        super.init(shortName:symbol)
        }
        
    internal var displayString:String
        {
        var types = self.associatedTypes.map{$0.shortName}.joined(separator: ",")
        if !types.isEmpty
            {
            types = "(" + types + ")"
            }
        return("\(self.shortName)\(types)")
        }
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try value?.allocateAddresses(using:compiler)
        }
    
}
