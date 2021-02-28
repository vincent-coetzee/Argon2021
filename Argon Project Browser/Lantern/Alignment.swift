//
//  Alignment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Foundation

public class Alignment:OptionSet
    {
    public let rawValue:Int

    public typealias RawValue = Int

    static let left = Alignment(rawValue: 1 << 0)
    static let center = Alignment(rawValue: 1 << 1)
    static let right = Alignment(rawValue: 1 << 2)
    static let justified = Alignment(rawValue: 1 << 3)
    static let top = Alignment(rawValue: 1 << 4)
    static let middle = Alignment(rawValue: 1 << 5)
    static let bottom = Alignment(rawValue: 1 << 6)

    required public init(rawValue:Int)
        {
        self.rawValue = rawValue
        }
    }
