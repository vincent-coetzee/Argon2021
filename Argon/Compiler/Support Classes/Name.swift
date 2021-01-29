//
//  Name.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 02/03/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
    
public struct Name:Hashable,ExpressibleByArrayLiteral,Codable
    {
    public enum NameComponent:Hashable,Codable
        {
        enum CodingKeys:String,CodingKey
            {
            case kind
            case string
            }
            
        public init(from decoder:Decoder) throws
            {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let kind = try values.decode(Int.self,forKey:.kind)
            if kind == 1
                {
                self = .anchor
                }
            else
                {
                self = .element(try values.decode(String.self,forKey:.string))
                }
            try self.init(from:decoder)
            }
            
        public func encode(to encoder: Encoder) throws
            {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch(self)
                {
                case .anchor:
                    try container.encode(1,forKey:.kind)
                case .element(let string):
                    try container.encode(2,forKey:.kind)
                    try container.encode(string,forKey:.string)

                }
            }
            
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
                    return("/")
                case .element(let string):
                    return(string)
                }
            }
        }
    
    public var displayString:String
        {
        return(self.stringName)
        }
        
    public static func +(lhs:Name,rhs:String) -> Name
        {
        return(Name(lhs.components.map{$0.string} + [rhs]))
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
        return("//"+self.components.map{$0.string}.joined(separator: "/"))
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
        return(self.components.map{$0.isAnchor ? "/" : $0.string})
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
        
    public init(_ components:[String])
        {
        self.components = components.map{.element($0)}
        }
        
    public init(_ piece:String)
        {
        let pieces = piece.components(separatedBy: "/")
        if pieces.count > 0 && pieces.first!.isEmpty
            {
            self.components = Array(pieces.dropFirst()).map{.element($0)}
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
    }
