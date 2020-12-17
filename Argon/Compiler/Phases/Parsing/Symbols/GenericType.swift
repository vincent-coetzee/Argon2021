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
        
    internal init(shortName:String,constraints:[Type])
        {
        self.constraints = constraints
        super.init(shortName: shortName)
        }
    
    internal required init(_ parser: Parser)
        {
        fatalError("init(_:) has not been implemented")
        }
    
    internal required init() {
        self.constraints = []
        super.init(shortName: "")
    }
}

typealias GenericTypes = Array<GenericType>
