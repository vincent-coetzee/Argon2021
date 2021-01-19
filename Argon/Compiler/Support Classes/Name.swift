//
//  Name.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 02/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public struct Name:Hashable,ExpressibleByArrayLiteral,ThreeAddress
    {
    public var displayString:String
        {
        return(self.stringName)
        }
        
    public static func +(lhs:Name,rhs:String) -> Name
        {
        return(Name(lhs.components + [rhs]))
        }
        
    public static func +(lhs:Name,rhs:Name) -> Name
        {
        return(Name(lhs.components + rhs.components))
        }

    @discardableResult
    public static func +=(lhs:inout Name,rhs:String) -> Name
        {
        var total = lhs.components
        total.append(rhs)
        lhs = Name(total)
        return(lhs)
        }
        
    public typealias ArrayLiteralElement = String
    
    public init(arrayLiteral arrayLiteralElement:String...)
        {
        for element in arrayLiteralElement
            {
            self.components.append(element)
            }
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
        if self.components.isEmpty
            {
            return("")
            }
        if self.components.count == 1
            {
            return("/\(self.components.first!)")
            }
        return("//"+self.components.joined(separator: "/"))
        }
        
    public var first:String
        {
        if self.components.count < 1
            {
            fatalError("Attempt to access first element of name when name has 0 length.")
            }
        return(self.components[0])
        }
        
    public var last:String
        {
        if self.components.count < 1
            {
            fatalError("Attempt to access last element of name when name has 0 length.")
            }
        return(self.components.last!)
        }
        
    public var names:[String]
        {
        return(self.components)
        }
        
    private var components:[String] = []
    
    public func withoutFirst() -> Name
        {
        if self.components.count < 1
            {
            return(self)
            }
        return(Name(Array(self.components.dropFirst())))
        }
        
    public func withoutLast() -> Name
        {
        if self.components.count < 1
            {
            return(self)
            }
        return(Name(Array(self.components.dropLast())))
        }
        
    public init(_ components:[String])
        {
        self.components = components
        }
        
    public init(_ piece:String)
        {
        self.components = piece.components(separatedBy: "/")
        if self.components.count > 0 && self.components.first!.isEmpty
            {
            self.components = Array(self.components.dropFirst())
            }
        }
        
    public init()
        {
        self.components = []
        }
    }
