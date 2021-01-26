//
//  DateTimeExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class DateTimeValueExpression:ScalarExpression
    {
    let date:Expression
    let time:Expression
    
    init(date:Expression,time:Expression)
        {
        self.date = date
        self.time = time
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        }
    }

