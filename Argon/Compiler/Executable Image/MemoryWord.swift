//
//  MemoryWord.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public enum MemoryWord:Codable
    {
    case integer(Argon.Integer)
    case float(Argon.Float)
    case pointer(MemoryAddress)
    case boolean(Argon.Boolean)
    case byte(Argon.Byte)
    case character(Argon.Character)
    
    enum CodingKeys:String,CodingKey
        {
        case character
        case byte
        case pointer
        case float
        case integer
        case boolean
        case kind
        }
        
    public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try values.decode(Int.self,forKey:.kind)
        if kind == 1
            {
            self = .integer(try values.decode(Argon.Integer.self,forKey:.integer))
            }
        else if kind == 2
            {
            self = .float(try values.decode(Argon.Float.self,forKey:.float))
            }
        else if kind == 3
            {
            self = .pointer(try values.decode(MemoryAddress.self,forKey:.pointer))
            }
        else if kind == 4
            {
            self = .byte(try values.decode(Argon.Byte.self,forKey:.byte))
            }
        else if kind == 5
            {
            self = .character(try values.decode(Argon.Character.self,forKey:.character))
            }
        else if kind == 6
            {
            self = .boolean(try values.decode(Argon.Boolean.self,forKey:.boolean))
            }
        try self.init(from:decoder)
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch(self)
            {
            case .integer(let integer):
                try container.encode(1,forKey:.kind)
                try container.encode(integer,forKey:.integer)
            case .float(let float):
                try container.encode(2,forKey:.kind)
                try container.encode(float,forKey:.float)
            case .pointer(let address):
                try container.encode(3,forKey:.kind)
                try container.encode(address,forKey:.pointer)
                try container.encode(address,forKey:.float)
            case .byte(let byte):
                try container.encode(4,forKey:.kind)
                try container.encode(byte,forKey:.byte)
            case .character(let char):
                try container.encode(5,forKey:.kind)
                try container.encode(char,forKey:.character)
            case .boolean(let boolean):
                try container.encode(3,forKey:.kind)
                try container.encode(boolean,forKey:.boolean)
            }
        }
    }
