//
//  SequenceGeneratorClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class SequenceGeneratorClass:Class
    {
    let baseClass:Class
    let start:Expression
    let end:Expression
    let step:Expression
    let range:Token.Symbol
    
    init(baseClass:Class,start:Expression,step:Expression,end:Expression,range:Token.Symbol)
        {
        self.baseClass = baseClass
        self.start = start
        self.step = step
        self.end = end
        self.range = range
        super.init(shortName:Argon.nextName("SEQUENCE"))
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    }

