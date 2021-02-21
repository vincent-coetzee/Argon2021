//
//  TupleClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class TupleClass:Class
    {
    let elements:[Class]
    
    init(elements:[Class])
        {
        self.elements = elements
        super.init(shortName:"TUPLE_\(Argon.nextIndex())")
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
}

