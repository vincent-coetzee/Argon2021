//
//  StaticSegment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class StaticSegment:MemorySegment
    {
    public override var segment:SegmentIdentifier
        {
        return(.static)
        }
    }
