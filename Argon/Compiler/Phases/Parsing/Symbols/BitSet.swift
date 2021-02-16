//
//  BitSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/05.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public struct BitSetField
    {
    let name:String
    let offset:Argon.Integer
    var width:Argon.Integer = 0
    
    init(name:String,offset:Argon.Integer,width:Argon.Integer)
        {
        self.name = name
        self.offset = offset
        self.width = width
        }
    }
    
public class BitSet:Symbol
    {
    let valueClass:Class
    var keyClass:Class?
    
    internal override var typeClass:Class
        {
        return(Class.bitSetClass)
        }
        
    var fields:[String:BitSetField] = [:]
    
    init(shortName:String,keyClass:Class? = nil,valueClass:Class)
        {
        self.valueClass = valueClass
        self.keyClass = keyClass
        super.init(shortName:shortName)
        }
    
    public var inferredBaseTypeClass:Class
        {
        return(.wordClass)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    func addField(_ field:BitSetField)
        {
        self.fields[field.name] = field
        }
}

public class BitSetMaker:Method
    {
    init(shortName:String,bitSet:BitSet)
        {
        super.init(shortName:shortName)
        let instance = MethodInstance(shortName: shortName, owner: self)
        instance.addParameter(Parameter(shortName:"value", type:bitSet.inferredBaseTypeClass, hasTag:true))
        instance.returnTypeClass = bitSet.typeClass
        self.addInstance(instance)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
