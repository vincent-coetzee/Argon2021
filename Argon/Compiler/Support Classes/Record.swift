//
//  Protocols.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/21.
//

import Foundation
    
public protocol Record
    {
    var recordKind:RecordKind { get }
    var id:UUID { get }
    func write(file:ObjectFile) throws
    init(file:ObjectFile) throws
    }

extension Record
    {
    var isObject:Bool
        {
        return(!((Swift.type(of:self) as? AnyClass) == nil))
        }
    }
    
public typealias Maker = (_ file:ObjectFile) throws -> Record

public struct EmptyRecord:Record
    {
    public var recordKind: RecordKind
        {
        return(.none)
        }
        
    public var id: UUID = UUID()
    
    public func write(file: ObjectFile) throws
        {
        }
    
    public init(file: ObjectFile) throws
        {
        }
    
    }
    
public enum RecordKind:Int
    {
    case none
    case module
    case `class`
    case enumeration
    case type
    case valueClass
    case method
    case methodInstance
    case function
    case sourceReference
    case importVector
    case `import`
    case constant
    case variable
    case slot
    case name
    case instruction
    case instructionResult
    case instructionLeftHS
    case instructionRightHS
    case instructionLabel
    case instructionBuffer
    case instructionOpcode
    case array
    case reference
    case sourceLocation
    case expression
    
    func kindMaker() -> Maker
        {
        switch(self)
            {
            case .module:
                return({ (file:ObjectFile) throws -> Record in return(try Module(file:file))})
            case .class:
                return({ (file:ObjectFile) throws -> Record in return(try Class(file:file))})
            case .enumeration:
                return({ (file:ObjectFile) throws -> Record in return(try Enumeration(file:file))})
            case .type:
                return({ (file:ObjectFile) throws -> Record in return(try TypeSymbol(file:file))})
            case .valueClass:
                return({ (file:ObjectFile) throws -> Record in return(try ValueClass(file:file))})
            case .method:
                return({ (file:ObjectFile) throws -> Record in return(try Method(file:file))})
            case .methodInstance:
                return({ (file:ObjectFile) throws -> Record in return(try MethodInstance(file:file))})
            case .function:
                return({ (file:ObjectFile) throws -> Record in return(try Function(file:file))})
            case .sourceReference:
                return({ (file:ObjectFile) throws -> Record in return(try SourceReference(file:file))})
            case .importVector:
                return({ (file:ObjectFile) throws -> Record in return(try ImportVector(file:file))})
            case .import:
                return({ (file:ObjectFile) throws -> Record in return(try Import(file:file))})
            case .constant:
                return({ (file:ObjectFile) throws -> Record in return(try Constant(file:file))})
            case .variable:
                return({ (file:ObjectFile) throws -> Record in return(try Variable(file:file))})
            case .slot:
                return({ (file:ObjectFile) throws -> Record in return(try Slot(file:file))})
            case .name:
                return({ (file:ObjectFile) throws -> Record in return(try Name(file:file))})
            case .instruction:
                return({ (file:ObjectFile) throws -> Record in return(try ThreeAddressInstruction(file:file))})
            default:
                    fatalError("Should not be called")
            }
        }
    }
