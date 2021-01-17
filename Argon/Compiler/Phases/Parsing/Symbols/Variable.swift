//
//  Variable.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Variable:Symbol,ThreeAddress
    {
    public static let none = Variable(shortName:"NONE",class:.voidClass)
    
    public var displayString:String
        {
        return(self.shortName)
        }
        
    internal var isHollowVariable:Bool
        {
        return(false)
        }
        
    internal var canBeInvoked:Bool
        {
        return(self._class.shortName == "Closure" || self._class.shortName == "Function" || self._class.shortName == "Method")
        }
        
    internal var isArrayVariable:Bool
        {
        return(self._class.shortName == "Array")
        }
        
    internal var initialValue:Expression?
    
    internal override var typeClass:Class
        {
        return(self._class)
        }
        
    internal var location:ValueLocation = .none
    internal var _class:Class
    
    internal init(shortName:String,class:Class)
        {
        self._class = `class`
        super.init(shortName:shortName)
        }
        
    internal init(name:Name,class:Class)
        {
        self._class = `class`
        super.init(name:name)
        }
        
    internal required init()
        {
        self._class = RootModule.rootModule.nilInstance.typeClass
        super.init()
        }
        
    func generateIntermediateCodeLoad(target:ThreeAddress,into buffer:ThreeAddressInstructionBuffer)
        {
        buffer.emitInstruction(result:target,left:self,opcode:.assign)
        }
    }

public class HollowVariable:Variable
    {
    public static let sharedInstance = HollowVariable(shortName:"?",class:.voidClass)
    
    internal override var isHollowVariable:Bool
        {
        return(true)
        }
    }
