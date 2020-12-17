//
//  ClassMaker.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/11/16.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ClassMaker:Method
    {
    init(shortName:String,parameters:Parameters,block:Block)
        {
        super.init(shortName:shortName)
        self.parameters = parameters
        self.block = block
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    }

typealias ClassMakers = Array<ClassMaker>
