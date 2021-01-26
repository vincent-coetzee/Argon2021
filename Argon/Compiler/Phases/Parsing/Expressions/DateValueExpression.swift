//
//  DateValueExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class DateValueExpression:ScalarExpression
    {
    let day:Expression
    let month:Expression
    let year:Expression
    
    init(day:Expression,month:Expression,year:Expression)
        {
        self.day = day
        self.month = month
        self.year = year
        super.init()
        }
    }

