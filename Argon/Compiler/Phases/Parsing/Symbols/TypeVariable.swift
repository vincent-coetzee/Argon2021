//
//  TypeVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/18.
//

import Foundation

public class TypeVariable:Symbol
    {
    public static var voidTypeVariable:TypeVariable
        {
        return(TypeVariable(shortName: "", class: .voidClass))
        }
        
    internal var concreteClass:Class?
    
    init(shortName:String,class:Class? = nil)
        {
        self.concreteClass = `class`
        super.init(shortName:shortName)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    
public class AssociationTypeVariable:TypeVariable
    {
    private let keyType:Class
    private let valueType:Class
    
    init(shortName:String,keyType:Class,valueType:Class)
        {
        self.keyType = keyType
        self.valueType = valueType
        super.init(shortName:shortName)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
public typealias TypeVariables = Array<TypeVariable>
