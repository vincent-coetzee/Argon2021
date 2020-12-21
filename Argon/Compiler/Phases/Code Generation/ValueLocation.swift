//
//  ValueLocation.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation

public struct ValueLocation
    {
    public static let none = ValueLocation()
    
    public var relativeAddress:RelativeAddress?
    public var absoluteAddress:Address?
    public var register:Register?
    }
