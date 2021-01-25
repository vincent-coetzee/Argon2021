//
//  ThreeAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public protocol ThreeAddress
    {
    var displayString:String { get }
    func write(file:ObjectFile) throws
    }
