//
//  SlotAttributes.swift
//  spark
//
//  Created by Vincent Coetzee on 31/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal struct SlotAttributes:OptionSet
    {
    let rawValue:Int

    typealias RawValue = Int

    static let readonly = SlotAttributes(rawValue: 1 << 0)
    static let readwrite = SlotAttributes(rawValue: 1 << 1)
    static let `class` = SlotAttributes(rawValue: 1 << 2)
    static let virtual = SlotAttributes(rawValue: 1 << 3)
    static let module = SlotAttributes(rawValue: 1 << 4)
    static let constant = SlotAttributes(rawValue: 1 << 5)
    static let alias = SlotAttributes(rawValue: 1 << 6)
    static let meta = SlotAttributes(rawValue: 1 << 7)
    static let value = SlotAttributes(rawValue: 1 << 8)
    }
