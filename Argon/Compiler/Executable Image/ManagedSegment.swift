//
//  ManagedSegment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public class ManagedSegment:MemorySegment
    {
    public override var segment:SegmentIdentifier
        {
        return(.managed)
        }
    }
