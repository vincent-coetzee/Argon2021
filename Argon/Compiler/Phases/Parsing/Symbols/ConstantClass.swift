//
//  ConstantClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class ConstantClass:ValueClass
    {
    let _class:Class
    
    override init(shortName:String)
        {
        self._class = .voidClass
        super.init(shortName:shortName)
        }
        
    init(shortName:String,class:Class)
        {
        self._class = `class`
        super.init(shortName:shortName)
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
}

