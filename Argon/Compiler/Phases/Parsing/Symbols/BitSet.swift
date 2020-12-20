//
//  BitSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/05.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public class BitSetField
    {
    let name:String
    let offset:Expression
    var width = 0
    
    init(name:String,offset:Expression)
        {
        self.name = name
        self.offset = offset
        }
        
    init(name:Name,offset:Expression)
        {
        self.name = name.first
        self.offset = offset
        }
    }
    
public class BitSet:Symbol
    {
    let valueTypeName:String
    var keyTypeName:String?
    
    var fields:[String:BitSetField] = [:]
    
    init(shortName:String,keyTypeName:String? = nil,valueTypeName:String)
        {
        self.valueTypeName = valueTypeName
        self.keyTypeName = keyTypeName
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    func addField(_ field:BitSetField)
        {
        self.fields[field.name] = field
        }
}
