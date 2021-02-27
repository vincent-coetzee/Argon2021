//
//  Array+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Foundation

extension Array where Element:Pane
    {
    @discardableResult
    public static func +(lhs:Panes,rhs:Pane) -> Panes
        {
        var newList = lhs
        newList.append(rhs)
        return(newList)
        }
        
    @discardableResult
    public static func +=(lhs:inout Panes,rhs:Pane) -> Panes
        {
        lhs.append(rhs)
        return(lhs)
        }
    }
