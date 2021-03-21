//
//  Constant.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/19.
//

import Cocoa

public class Constant:Variable,NSCoding
    {
    public override var browserCell:ItemBrowserCell
        {
        return(ItemConstantBrowserCell(constant:self))
        }
        
    public override var icon:NSImage
        {
        return(NSImage(named:"IconConstant64")!)
        }
        
    public var integerValue:Argon.Integer
        {
        if self.initialValue == nil
            {
            fatalError("Value of constant is nil and should not be")
            }
        return(self.initialValue!.integerValue)
        }
        
    public var isIntegerConstant:Bool
        {
        if let value = self.initialValue
            {
            return(value.isIntegerExpression)
            }
        return(false)
        }
        
    internal override var typeClass:Class
        {
        get
            {
            return(.constantClass)
            }
        set
            {
            }
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder:coder)
        }
    
    internal override init(shortName:String,class:Class)
        {
        super.init(shortName:shortName,class:`class`)
        }
        
    internal init(shortName:String,class:Class,value:Expression)
        {
        super.init(shortName:shortName,class:`class`)
        self.initialValue = value
        }
        
    internal init(shortName:String,class:Class,integer:Argon.Integer)
        {
        super.init(shortName:shortName,class:`class`)
        self.initialValue = LiteralIntegerExpression(integer: integer)
        }
        
    internal init(shortName:String,class:Class,string:Argon.String)
        {
        super.init(shortName:shortName,class:`class`)
        self.initialValue = LiteralStringExpression(string: string)
        }
        
    internal init(shortName:String,class:Class,float:Argon.Float)
        {
        super.init(shortName:shortName,class:`class`)
        self.initialValue = LiteralFloatExpression(float:float)
        }
        
    public func cloned(withValue:Expression) -> Constant
        {
        let oldClass = self._class
        return(Constant(shortName:self.shortName,class:oldClass,value:withValue))
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public override func encode(with coder: NSCoder)
        {
        super.encode(with:coder)
        }
        
   public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptConstant(self)
        }
    }
