//
//  Macro.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/09.
//

import Foundation

public class Macro:Symbol
    {
    private let argumentNames:Array<String>
    private let source:String
    
    init(shortName:String,argumentNames:Array<String>,source:String)
        {
        self.argumentNames = argumentNames
        self.source = source
        super.init(shortName: shortName)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
