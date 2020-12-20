//
//  Parameter.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 29/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal typealias ParameterTuple = (String?,Type)

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
        super.init(shortName:tuple.0 ?? "",type:tuple.1)
        }
        
    internal init(_ argument:Argument)
        {
        self.hasTag = argument.tag != nil
        self.showTag = true
        super.init(shortName: argument.tag ?? "",type: argument.type)
        }
        
    internal init(shortName:String,type:Type,hasTag:Bool = true)
        {
        self.hasTag = hasTag
        self.showTag = true
        super.init(shortName: shortName,type: type)
        }
    
    internal required init()
        {
        self.showTag = true
        self.hasTag = false
        super.init(shortName: "",type: Type.class(RootModule.rootModule.nilClass))
        }
    }

internal class NakedParameter:Parameter
    {
    }

public typealias Parameters = Array<Parameter>
