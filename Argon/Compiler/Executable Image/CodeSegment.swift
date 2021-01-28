//
//  CodeSegment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public class CodeSegment:MemorySegment
    {
    public override var segment:SegmentIdentifier
        {
        return(.code)
        }

    public func append(_ method:Method) -> MemoryAddress
        {
        return(.zero)
        }
    }
