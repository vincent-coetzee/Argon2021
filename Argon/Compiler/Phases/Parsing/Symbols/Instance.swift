//
//  Instance.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Instance:Symbol
    {
    internal let theClass:Class
    
    internal override var type:Type
        {
        return(self.theClass.type)
        }
        
    internal required init(class:Class)
        {
        self.theClass = `class`
        super.init(shortName:"Instance of '\(`class`.shortName)'")
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    }
