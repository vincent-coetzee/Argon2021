//
//  Variable.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Variable:Symbol
    {
    public static let none = Variable(shortName:"NONE",type:.void)
    
    internal var canBeInvoked:Bool
        {
        switch(self._type)
            {
            case .closure:
                return(true)
            case .function:
                return(true)
            case .method:
                return(true)
            default:
                return(false)
            }
        }
        
    internal var isArrayVariable:Bool
        {
        return(self._type.isArrayType)
        }
        
    internal var initialValue:Expression?
    
    internal override var type:Type
        {
        get
            {
            return(self._type)
            }
        set
            {
            self._type = newValue
            }
        }
        
    internal var _type:Type
    internal var location:ValueLocation = .none
        
    internal init(shortName:String,type:Type)
        {
        self._type = type
        super.init(shortName:shortName)
        }
        
    internal init(name:Name,type:Type)
        {
        self._type = type
        super.init(shortName:name.first)
        }
        
    internal required init()
        {
        self._type = RootModule.rootModule.nilInstance.type
        super.init()
        }
    }
