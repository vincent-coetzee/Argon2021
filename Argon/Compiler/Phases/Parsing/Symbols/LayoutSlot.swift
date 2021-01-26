//
//  LayoutSlot.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/19.
//

import Foundation

public enum LayoutSlot:Equatable,Codable
    {
    case slot(Slot)
    case offset(Int?)
    
    enum CodingKeys:String,CodingKey
        {
        case kind
        case slot
        case offset
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch(self)
            {
            case .slot(let slot):
                try container.encode(1,forKey:.kind)
                try container.encode(slot,forKey:.slot)
            case .offset(let offset):
                try container.encode(2,forKey:.kind)
                try container.encode(offset,forKey:.offset)
            }
        }
        
    public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try values.decode(Int.self,forKey:.kind)
        if kind == 1
            {
            self = .slot(try values.decode(Slot.self,forKey:.slot))
            }
        else if kind == 2
            {
            self = .offset(try values.decode(Int.self,forKey:.offset))
            }
        try self.init(from:decoder)
        }
    }
