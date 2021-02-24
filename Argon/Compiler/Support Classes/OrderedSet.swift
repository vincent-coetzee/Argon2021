//
//  OrderedSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/09.
//

import Foundation

public struct OrderedSet<Element>:Collection where Element:Hashable
    {
    @discardableResult
    public static func +(lhs:OrderedSet<Element>,rhs:Element) -> OrderedSet<Element>
        {
        var new = lhs
        new.insert(rhs)
        return(new)
        }
        
    public var startIndex:Int
        {
        return(self.items.startIndex)
        }
        
    public var endIndex:Int
        {
        return(self.items.endIndex)
        }
        
    var items:[Element] = []
    
    init(_ element:Element)
        {
        self.items = [element]
        }
        
    init(_ elements:[Element])
        {
        for element in elements
            {
            self.insert(element)
            }
        }
        
    init(_ elements:Set<Element>)
        {
        for element in elements
            {
            self.insert(element)
            }
        }
        
    init()
        {
        }
        
    mutating func insert(_ element:Element)
        {
        guard !self.items.contains(element) else
            {
            return
            }
        self.items.append(element)
        }
        
    func contains(_ element:Element) -> Bool
        {
        return(self.items.contains(element))
        }
        
    public subscript(_ index:Int) -> Element
        {
        return(self.items[index])
        }
        
    public func index(after:Int) -> Int
        {
        return(self.items.index(after:after))
        }
        
    public func flatMap<T>(_ closure:(Element)->T?) -> OrderedSet<T>
        {
        var newSet = OrderedSet<T>()
        for element in self.items
            {
            if let result = closure(element)
                {
                newSet.insert(result)
                }
            }
        return(newSet)
        }
    }

extension Collection
    {
    func collect<T>(_ closure:(Element) -> T) -> Array<T>
        {
        var newSet = Array<T>()
        for element in self
            {
            newSet.append(closure(element))
            }
        return(newSet)
        }
    }
