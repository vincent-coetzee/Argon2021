//
//  StackSegment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public class StackSegment:MemorySegment
    {
    public override var segment:SegmentIdentifier
        {
        return(.base)
        }
    }
