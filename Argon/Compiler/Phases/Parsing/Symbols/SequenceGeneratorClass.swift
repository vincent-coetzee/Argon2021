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
    
    init(baseClass:Class,start:Expression,step:Expression,end:Expression)
        {
        self.baseClass = baseClass
        self.start = start
        self.step = step
        self.end = end
        super.init(shortName:Argon.nextName("SEQUENCE"))
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    }

