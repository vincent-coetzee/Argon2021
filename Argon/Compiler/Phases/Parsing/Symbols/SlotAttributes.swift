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
    static let regular = SlotAttributes(rawValue: 1 << 2)
    static let virtual = SlotAttributes(rawValue: 1 << 3)
    static let module = SlotAttributes(rawValue: 1 << 4)
    static let constant = SlotAttributes(rawValue: 1 << 5)
    static let alias = SlotAttributes(rawValue: 1 << 6)
    static let `class` = SlotAttributes(rawValue: 1 << 7)
    static let value = SlotAttributes(rawValue: 1 << 8)
    
    public init(storageKind:StorageKind)
        {
        self.rawValue = storageKind.integerKind
        }
        
        
    public init(rawValue:Int)
        {
        self.rawValue = rawValue
        }
        
//    public init(file:BinaryFile) throws
//        {
//        let kind = try file.readString()
//        switch(kind)
//            {
//            case "r":
//                self = .readonly
//            case "w":
//                self = .readwrite
//            case "g":
//                self = .regular
//            case "v":
//                self = .virtual
//            case "m":
//                self = .module
//            case "c":
//                self = .constant
//            case "a":
//                self = .alias
//            case "l":
//                self = .class
//            default:
//                fatalError("Error encoding")
//            }
//        }
        
    var encodedString:String
        {
        var string = ""
        if self.contains(Self.readonly)
            {
            string += "r"
            }
        if self.contains(Self.readwrite)
            {
            string += "w"
            }
        if self.contains(Self.regular)
            {
            string += "g"
            }
        if self.contains(Self.virtual)
            {
            string += "v"
            }
        if self.contains(Self.module)
            {
            string += "m"
            }
        if self.contains(Self.constant)
            {
            string += "c"
            }
        if self.contains(Self.alias)
            {
            string += "a"
            }
        if self.contains(Self.class)
            {
            string += "l"
            }
        if self.contains(Self.value)
            {
            string += "u"
            }
        return(string)
        }
    }
