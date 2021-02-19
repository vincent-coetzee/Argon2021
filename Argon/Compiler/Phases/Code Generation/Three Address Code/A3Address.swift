//
//  ThreeAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public enum A3Address
    {
    var displayString:String
        {
        switch(self)
            {
            case .string(let string):
                return(string)
            case .integer(let integer):
                return("\(integer)")
            case .variable(let variable):
                return(variable.shortName)
            case .localVariable(let string):
                return(string.shortName)
            case .parameter(let parameter):
                return(parameter.shortName)
            case .label(let label):
                return(label.displayString)
            case .register(let register):
                return(register.displayString)
            case .constant(let constant):
                return(constant.shortName)
            case .temporary(let temporary):
                return(temporary.displayString)
            case .name(let name):
                return(name.displayString)
            case .argument(let argument):
                return(argument.displayString)
            case .method(let method):
                return(method.shortName)
            case .class(let aClass):
                return(aClass.shortName)
            case .float(let float):
                return("\(float)")
            case .closure(let closure):
                return(closure.displayString)
            case .address(let address):
                return(address.displayString)
            case .boolean(let boolean):
                return(boolean == .trueValue ? "#true" : "#false")
            case .none:
                return("ERROR")
            }
        }
    
    case none
    case string(Argon.String)
    case integer(Argon.Integer)
    case boolean(Argon.Boolean)
    case variable(Variable)
    case localVariable(LocalVariable)
    case parameter(Parameter)
    case label(A3Label)
    case register(Register)
    case constant(Constant)
    case temporary(A3Temporary)
    case name(Name)
    case argument(Argument)
    case method(Method)
    case `class`(Class)
    case float(Argon.Float)
    case closure(Closure)
    case address(MemoryAddress)
    
//    enum CodingKeys:String,CodingKey
//        {
//        case kind
//        case string
//        case integer
//        case variable
//        case localVariable
//        case parameter
//        case label
//        case register
//        case constant
//        case temporary
//        case name
//        case argument
//        case method
//        case `class`
//        case float
//        case closure
//        case address
//        }
//        
//    public init(from decoder:Decoder) throws
//        {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let kind = try values.decode(Int.self,forKey:.kind)
//        if kind == 1
//            {
//            self = .string(try values.decode(String.self,forKey:.string))
//            }
//        else if kind == 2
//            {
//            self = .integer(try values.decode(Argon.Integer.self,forKey:.integer))
//            }
//        else if kind == 3
//            {
//            self = .variable(try values.decode(Variable.self,forKey:.variable))
//            }
//        else if kind == 4
//            {
//            self = .localVariable(try values.decode(LocalVariable.self,forKey:.localVariable))
//            }
//        else if kind == 5
//            {
//            self = .parameter(try values.decode(Parameter.self,forKey:.parameter))
//            }
//        else if kind == 6
//            {
//            self = .label(try values.decode(A3Label.self,forKey:.label))
//            }
//        else if kind == 7
//            {
//            self = .register(try values.decode(Register.self,forKey:.register))
//            }
//        else if kind == 8
//            {
//            self = .constant(try values.decode(Constant.self,forKey:.constant))
//            }
//        else if kind == 9
//            {
//            self = .temporary(try values.decode(A3Temporary.self,forKey:.temporary))
//            }
//        else if kind == 10
//            {
//            self = .name(try values.decode(Name.self,forKey:.name))
//            }
//        else if kind == 11
//            {
//            self = .argument(try values.decode(Argument.self,forKey:.argument))
//            }
//        else if kind == 12
//            {
//            self = .method(try values.decode(Method.self,forKey:.method))
//            }
//        else if kind == 13
//            {
//            self = .class(try values.decode(Class.self,forKey:.class))
//            }
//        else if kind == 14
//            {
//            self = .float(try values.decode(Argon.Float.self,forKey:.float))
//            }
//        else if kind == 15
//            {
//            self = .closure(try values.decode(Closure.self,forKey:.closure))
//            }
//        else
//            {
//            self = .none
//            }
//        }
//        
//    public func encode(to encoder: Encoder) throws
//        {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch(self)
//            {
//            case .string(let string):
//                try container.encode(1,forKey:.kind)
//                try container.encode(string,forKey:.string)
//            case .integer(let integer):
//                try container.encode(2,forKey:.kind)
//                try container.encode(integer,forKey:.integer)
//            case .variable(let variable):
//                try container.encode(3,forKey:.kind)
//                try container.encode(variable,forKey:.variable)
//            case .localVariable(let string):
//                try container.encode(4,forKey:.kind)
//                try container.encode(string,forKey:.localVariable)
//            case .parameter(let parameter):
//                try container.encode(5,forKey:.kind)
//                try container.encode(parameter,forKey:.parameter)
//            case .label(let label):
//                try container.encode(6,forKey:.kind)
//                try container.encode(label,forKey:.label)
//            case .register(let register):
//                try container.encode(7,forKey:.kind)
//                try container.encode(register,forKey:.register)
//            case .constant(let constant):
//                try container.encode(8,forKey:.kind)
//                try container.encode(constant,forKey:.constant)
//            case .temporary(let temporary):
//                try container.encode(9,forKey:.kind)
//                try container.encode(temporary,forKey:.temporary)
//            case .name(let name):
//                try container.encode(10,forKey:.kind)
//                try container.encode(name,forKey:.name)
//            case .argument(let argument):
//                try container.encode(11,forKey:.kind)
//                try container.encode(argument,forKey:.argument)
//            case .method(let method):
//                try container.encode(12,forKey:.kind)
//                try container.encode(method,forKey:.method)
//            case .class(let aClass):
//                try container.encode(13,forKey:.kind)
//                try container.encode(aClass,forKey:.class)
//            case .float(let float):
//                try container.encode(14,forKey:.kind)
//                try container.encode(float,forKey:.float)
//            case .closure(let closure):
//                try container.encode(15,forKey:.kind)
//                try container.encode(closure,forKey:.closure)
//            case .address(let address):
//                try container.encode(16,forKey:.kind)
//                try container.encode(address,forKey:.address)
//            case .none:
//                break
//            }
//        }
        
    }
