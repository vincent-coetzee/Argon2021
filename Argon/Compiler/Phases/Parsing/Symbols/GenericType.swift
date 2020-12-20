//
//  TypeVariable.swift
//  spark
//
//  Created by Vincent Coetzee on 22/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class GenericType:Symbol
    {
    internal let constraints:[Type]
    
    internal class func generic(_ name:String,_ constraints:Type...) -> GenericType
        {
        return(GenericType(shortName: name,constraints: constraints))
        }
        
    internal class func generic(_ name:Name,_ constraints:Type...) -> GenericType
        {
        return(GenericType(shortName: name.first,constraints: constraints))
        }
        
    internal init(_ type:Type)
        {
        self.constraints = []
        super.init(shortName:"_GENERIC_\(Argon.nextIndex())_\(type)")
        }
        
    internal init(shortName:String,constraints:[Type])
        {
        self.constraints = constraints
        super.init(shortName: shortName)
        }
        
    internal init(name:Name,constraints:[Type])
        {
        self.constraints = constraints
        super.init(shortName: name.first)
        }
    
    internal required init() {
        self.constraints = []
        super.init(shortName: "")
    }
}

typealias GenericTypes = Array<GenericType>
