//
//  ForInductionVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ForInductionVariable:InductionVariable
    {
    init(shortName:String)
        {
        super.init(shortName:shortName,class:Class.voidClass)
        }
    
    internal required init()
        {
        super.init()
        }
        
    public required init(file:ObjectFile) throws
        {
        fatalError()
        }
}
