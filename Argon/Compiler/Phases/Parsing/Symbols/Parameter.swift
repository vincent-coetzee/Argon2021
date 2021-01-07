//
//  Parameter.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 29/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal typealias ParameterTuple = (String?,Class)

public class Parameter:Variable
    {
    internal var showTag:Bool
    private var hasTag:Bool
    private var tag:String = ""
    
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
        
    internal init(_ tuple:ParameterTuple)
        {
        self.hasTag = tuple.0 != nil
        self.tag = tuple.0 ?? ""
        self.showTag = tuple.0 != nil
        super.init(shortName:tuple.0 ?? "",class:tuple.1)
        }
        
    internal init(_ argument:Argument)
        {
        self.hasTag = argument.tag != nil
        self.showTag = true
        super.init(shortName: argument.tag ?? "",class: argument.typeClass)
        }
        
    internal init(shortName:String,type:Class,hasTag:Bool = true)
        {
        self.hasTag = hasTag
        self.showTag = true
        super.init(shortName: shortName,class: type)
        }
    
    internal required init()
        {
        self.showTag = true
        self.hasTag = false
        super.init(shortName: "",class: .voidClass)
        }
    }

internal class NakedParameter:Parameter
    {
    }

public typealias Parameters = Array<Parameter>
