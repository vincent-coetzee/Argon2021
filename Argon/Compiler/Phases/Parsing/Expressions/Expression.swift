//
//  Expression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/10/24.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Expression:Equatable
    {
    public var id: UUID    
    private let location:SourceLocation
    internal let intermediateCodeBuffer = A3CodeBuffer()
    
    public var isHollowVariableExpression:Bool
        {
        return(false)
        }
        
    public var typeClass:Class
        {
        return(Class.voidClass)
        }
        
    public static func ==(lhs:Expression,rhs:Expression) -> Bool
        {
        return(false)
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        fatalError("Not Implemnted")
        }
        
    init(location:SourceLocation = .zero)
        {
        self.location = location
        self.id = UUID()
        }
        
    internal func generateIntermediatePushCode(into buffer:A3CodeBuffer)
        {
        fatalError("This should have been overridden")
        }
    }
    
