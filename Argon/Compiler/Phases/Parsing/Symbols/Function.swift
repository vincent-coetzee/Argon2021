//
//  Function.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Function:MethodInstance
    {
    public var cName:String? = nil
    public var libraryName:String = ""
    
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    init(shortName:String)
        {
        super.init(shortName:shortName)
        }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }

public class ModuleFunction:Function
    {
    override init(shortName:String)
        {
        super.init(shortName:shortName)
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }
