//
//  SourceReference.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum SourceReference:Codable
    {
    enum CodingKeys:String,CodingKey
        {
        case kind
        case location
        }
        
    public init(from decoder: Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try values.decode(Int.self,forKey:.kind)
        let location = try values.decode(SourceLocation.self,forKey:.location)
        if kind == 1
            {
            self = .declaration(location)
            }
        else if kind == 2
            {
            self = .read(location)
            }
        else
            {
            self = .write(location)
            }
        }
    
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch(self)
            {
            case .declaration(let location):
                try container.encode(1, forKey: .kind)
                try container.encode(location,forKey:.location)
            case .read(let location):
                try container.encode(2, forKey: .kind)
                try container.encode(location,forKey:.location)
            case .write(let location):
                try container.encode(3, forKey: .kind)
                try container.encode(location,forKey:.location)
            }
        }
    
    public var id:UUID
        {
        return(UUID())
        }
        
    public var className:String
        {
        return("SourceReference")
        }
    
    public  var rawValue:Int
        {
        switch(self)
            {
            case .declaration:
                return(1)
            case .read:
                return(2)
            case .write:
                return(3)
            }
        }
        
    public var location:SourceLocation
        {
        switch(self)
            {
            case .declaration(let location):
                return(location)
            case .read(let location):
                return(location)
            case .write(let location):
                return(location)
            }
        }
    
    case declaration(SourceLocation)
    case read(SourceLocation)
    case write(SourceLocation)
    }
