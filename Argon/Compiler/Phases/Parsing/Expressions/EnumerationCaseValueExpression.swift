//
//  EnumerationCaseValueExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class EnumerationCaseValueExpression:ScalarExpression
    {
    public override var typeClass:Class
        {
        return(EnumerationCaseClass(shortName: self.name,enumeration: enumeration.typeClass as! EnumerationClass))
        }
        
    let name:String
    let enumerationCase:EnumerationCase
    let enumeration:Enumeration
    
    init(name:String,enumeration:Enumeration,case:EnumerationCase)
        {
        self.name = name
        self.enumerationCase = `case`
        self.enumeration = enumeration
        super.init()
        }
    }
