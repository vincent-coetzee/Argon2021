//
//  DictionaryClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class DictionaryClass:CollectionClass
    {
    public let keyTypeClass:Class
    public let valueTypeClass:Class
    
    init(shortName:String,keyTypeClass:Class,valueTypeClass:Class)
        {
        self.keyTypeClass = keyTypeClass
        self.valueTypeClass = valueTypeClass
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) -> Class
        {
        return(DictionaryClass(shortName:Argon.nextName("DICTIONARY"),keyTypeClass:self.keyTypeClass,valueTypeClass:self.valueTypeClass))
        }
    }
