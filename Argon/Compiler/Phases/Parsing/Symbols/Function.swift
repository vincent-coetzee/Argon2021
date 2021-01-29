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
    
    enum CodingKeys:String,CodingKey
        {
        case cName
        case libraryName
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.cName = try values.decode(String?.self,forKey:.cName)
        self.libraryName = try values.decode(String.self,forKey:.libraryName)
        try super.init(from: values.superDecoder())
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    init(shortName:String)
        {
        super.init(shortName:shortName)
        }
    
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.cName,forKey:.cName)
        try container.encode(self.libraryName,forKey:.libraryName)
        try super.encode(to: container.superEncoder())
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
    
    required public init(from decoder: Decoder) throws
        {
        try super.init(from: decoder)
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        try super.encode(to:encoder)
        }
    }
