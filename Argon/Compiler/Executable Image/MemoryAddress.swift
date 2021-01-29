//
//  MemoryAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public class MemoryAddress:Codable
    {
    public static let zero = MemoryAddress(segment: MemorySegment(),offset:0)
    
    public var taggedAddress:Word
        {
        let tag = Tag.address.rawValue << Tag.kShift
        let segmentValue = self.segment.segment.bits << 60
        let value = tag | segmentValue | Word(offset)
        return(value)
        }
        
    public var word:Word
        {
        get
            {
            return(segment.word(at:self.offset))
            }
        set
            {
            self.segment.setWord(newValue,at:self.offset)
            }
        }
        
    enum CodingKeys:String,CodingKey
        {
        case segment
        case offset
        }
        
    let segment:MemorySegment
    public var offset:Int
    
    public var displayString:String
        {
        return("\(segment.segment):\(offset)")
        }
        
    init(segment:MemorySegment,offset:Int)
        {
        self.segment = segment
        self.offset = offset
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = SegmentIdentifier(rawValue: try values.decode(String.self,forKey:.segment))!
        self.segment = Compiler.shared.segmentAtIdentifier(identifier)
        self.offset =  try values.decode(Int.self,forKey:.offset)
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(segment.segment.rawValue,forKey:.segment)
        try container.encode(offset,forKey:.offset)
        }
    }
