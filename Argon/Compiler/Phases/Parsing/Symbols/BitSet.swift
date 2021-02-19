//
//  BitSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/05.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public class BitSetField:NSObject,NSCoding
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
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.name,forKey:"name")
        coder.encode(self.offset,forKey:"offset")
        coder.encode(self.width,forKey:"with")
        }
    
    required public init?(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey:"name") as! String
        self.offset = coder.decodeInt64(forKey:"offset")
        self.width = coder.decodeInt64(forKey:"width")
        }
    }
    
public class BitSet:Symbol,NSCoding
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
    
    public override func encode(with coder: NSCoder)
        {
        super.encode(with:coder)
        coder.encode(self.valueClass,forKey:"valueClass")
        coder.encode(self.keyClass,forKey:"keyClass")
        coder.encode(self.fields,forKey:"fields")
        }
    
    public required init?(coder: NSCoder)
        {
        self.valueClass = coder.decodeObject(forKey:"valueClass") as! Class
        self.keyClass = coder.decodeObject(forKey:"keyClass") as! Class?
        self.fields = coder.decodeObject(forKey:"fields") as! Dictionary<String,BitSetField>
        super.init(coder:coder)
        }
        
   public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptBitSet(self)
        }
        
    public var inferredBaseTypeClass:Class
        {
        return(.wordClass)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
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
