//
//  Max+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/09.
//

import Foundation

public func max<T>(_ array:Array<T>) -> T where T:Comparable
    {
    guard !array.isEmpty else
        {
        fatalError("The passed in array may not be empty")
        }
    var value = array.first!
    for element in array
        {
        value = max(value,element)
        }
    return(value)
    }
