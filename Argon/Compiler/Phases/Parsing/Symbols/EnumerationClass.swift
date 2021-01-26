//
//  EnumerationClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class EnumerationClass:Class
    {
    let baseClass:Class
    
    init(shortName:String,baseClass:Class)
        {
        self.baseClass = baseClass
        super.init(shortName:shortName)
        }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
    
public class EnumerationCaseClass:Class
    {
    let enumeration:EnumerationClass
    
    init(shortName:String,enumeration:EnumerationClass)
        {
        self.enumeration = enumeration
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
