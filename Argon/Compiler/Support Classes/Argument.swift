//
//  Argument.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Argument:Symbol
    {
    internal var value:Expression
    internal var tag:String?
    
    internal override var type:Type
        {
        return(value.type)
        }
        
    internal init(tag:String? = nil,value:Expression)
        {
        self.tag = tag
        self.value = value
        super.init(shortName: tag ?? "")
        }
    
    internal required init()
        {
        self.value = Expression.none
        self.tag = nil
        super.init()
        }
    }


internal class NakedArgument:Argument
    {
    }

public typealias Arguments = Array<Argument>

extension Arguments
    {
    func typesPrefixed(by:Type) -> [Type]
        {
        var types = self.map{$0.type}
        types.append(by)
        return(types)
        }
    }
