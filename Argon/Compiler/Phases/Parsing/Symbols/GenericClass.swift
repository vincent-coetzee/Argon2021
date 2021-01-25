//
//  TypeVariable.swift
//  spark
//
//  Created by Vincent Coetzee on 22/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class GenericClass:Symbol
    {
    internal let constraints:[Class]
    
    internal class func generic(_ name:String,_ constraints:Class...) -> GenericClass
        {
        return(GenericClass(shortName: name,constraints: constraints))
        }
        
    internal class func generic(_ name:Name,_ constraints:Class...) -> GenericClass
        {
        return(GenericClass(shortName: name.first,constraints: constraints))
        }
        
    internal init(_ type:Class)
        {
        self.constraints = []
        super.init(shortName:"_GENERIC_\(Argon.nextIndex())_\(type)")
        }
        
    internal init(shortName:String,constraints:[Class])
        {
        self.constraints = constraints
        super.init(shortName: shortName)
        }
        
    internal init(name:Name,constraints:[Class])
        {
        self.constraints = constraints
        super.init(shortName: name.first)
        }
    
    internal required init() {
        self.constraints = []
        super.init(shortName: "")
    }
    
    public required init(file:ObjectFile) throws
        {
        fatalError()
        }
}

typealias GenericClasses = Array<GenericClass>
