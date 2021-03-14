//
//  Name.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 02/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public struct Name:Hashable,ExpressibleByArrayLiteral,Collection
    {
    public typealias Element = String
    
    public typealias Index = Int
    
    public static let anchor = Name(anchored:true)
    
    public static let kNameSeparator = "\\"
    
    public static func anchoredName() -> Name
        {
        return(Name(anchored:true))
        }
        
    public enum NameComponent:Hashable
        {
        case anchor
        case element(String)
        
        var isAnchor:Bool
            {
            switch(self)
                {
                case .anchor:
                    return(true)
                default:
                    return(false)
                }
            }
            
        var string:String
            {
            switch(self)
                {
                case .anchor:
                    return("")
                case .element(let string):
                    return(string)
                }
            }
        }
    
    public var startIndex:Int
        {
        return(0)
        }
        
    public var endIndex:Int
        {
        return(self.components.count)
        }
        
    public var displayString:String
        {
        return(self.stringName)
        }
        
    public static func +(lhs:Name,rhs:String) -> Name
        {
        return(Name(lhs.components + [NameComponent.element(rhs)]))
        }
        
    public static func +(lhs:Name,rhs:Name) -> Name
        {
        return(Name(lhs.components + rhs.components))
        }

    @discardableResult
    public static func +=(lhs:inout Name,rhs:String) -> Name
        {
        var total = lhs.components
        total.append(.element(rhs))
        lhs = Name(total)
        return(lhs)
        }

    public typealias ArrayLiteralElement = String
    
    public init(arrayLiteral arrayLiteralElement:String...)
        {
        for element in arrayLiteralElement
            {
            self.components.append(.element(element))
            }
        }
        
    public var isAnchored:Bool
        {
        return(self.components.first?.isAnchor ?? false)
        }
        
    public var isEmpty:Bool
        {
        return(self.components.isEmpty)
        }
        
    public var count:Int
        {
        return(self.components.count)
        }
        
    public var stringName:String
        {
        return(self.components.map{$0.string}.joined(separator: Self.kNameSeparator))
        }
        
    public var first:String
        {
        if self.components.count < 1
            {
            fatalError("Attempt to access first element of name when name has 0 length.")
            }
        return(self.components[0].string)
        }
        
    public var last:String
        {
        if self.components.count < 1
            {
            fatalError("Attempt to access last element of name when name has 0 length.")
            }
        return(self.components.last!.string)
        }
        
    public var names:[String]
        {
        return(self.components.map{$0.isAnchor ? Self.kNameSeparator : $0.string})
        }
        
    private var components:[NameComponent] = []
    
    public func withoutFirst() -> Name
        {
        if self.components.count < 1
            {
            return(self)
            }
        return(Name(Array(self.components.dropFirst())))
        }
        
    public func anchored() -> Name
        {
        if self.isAnchored
            {
            return(self)
            }
        let newComponents = [NameComponent.anchor] + self.components
        return(Name(newComponents))
        }
        
    public func withoutLast() -> Name
        {
        if self.components.count < 1
            {
            return(self)
            }
        return(Name(Array(self.components.dropLast())))
        }
        
    public init(_ components:[NameComponent])
        {
        self.components = components
        }
        
    public init(anchored:Bool)
        {
        if anchored
            {
            self.components = [.anchor]
            }
        else
            {
            self.components = []
            }
        }
        
    public init(_ components:[String])
        {
        self.components = components.map{.element($0)}
        }
        
    public init(_ piece:String)
        {
        let pieces = piece.components(separatedBy: Self.kNameSeparator)
        if pieces.count > 0 && pieces.first!.isEmpty
            {
            self.components = [NameComponent.anchor] + Array(pieces.dropFirst()).map{.element($0)}
            }
        else
            {
            self.components = pieces.map{NameComponent.element($0)}
            }
        }
        
    public init()
        {
        self.components = []
        }
        
    public subscript(index:Int) -> String
        {
        return(self.components[index].string)
        }
        
    public func index(after:Int) -> Int
        {
        return(after+1)
        }
    }
