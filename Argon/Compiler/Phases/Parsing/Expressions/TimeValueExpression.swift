//
//  TimeValueExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class TimeValueExpression:ScalarExpression
    {
    let hour:Expression
    let minute:Expression
    let second:Expression
    let millisecond:Expression?
    
    init(location:SourceLocation = .zero,hour:Expression,minute:Expression,second:Expression,millisecond:Expression? = nil)
        {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
        super.init(location:location)
        }
    }

