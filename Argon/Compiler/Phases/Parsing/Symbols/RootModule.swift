//
//  CobaltPackage.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class RootModule:Module
    {
    public let rootClass = Class.rootClass
    public let valueClass = Class.valueClass
    public let metaClass = Class.metaClass
    public let classClass = Class.classClass
    public let nilClass = Class.nilClass
    public let voidClass = Class.voidClass
    public let integerClass = Class.integerClass
    public let integer64Class = Class.integer64Class
    public let integer32Class = Class.integer32Class
    public let integer16Class = Class.integer16Class
    public let integer8Class = Class.integer8Class
    public let uintegerClass = Class.uIntegerClass
    public let uinteger64Class = Class.uInteger64Class
    public let uinteger32Class = Class.uInteger32Class
    public let uinteger16Class = Class.uInteger16Class
    public let uinteger8Class = Class.uInteger8Class
    public let floatClass = Class.floatClass
    public let float64Class = Class.float64Class
    public let float32Class = Class.float32Class
    public let float16Class = Class.float16Class
    public let byteClass = Class.byteClass
    public let characterClass = Class.characterClass
    public let booleanClass = Class.booleanClass
    public let stringClass = Class.stringClass
    public let symbolClass = Class.stringClass
    public let methodClass = Class.methodClass
    public let dateClass = Class.dateClass
    public let timeClass = Class.timeClass
    public let dateTimeClass = Class.dateTimeClass
    public let tupleClass = Class.tupleClass
    public let moduleClass = Class.moduleClass
    public let arrayClass = Class.arrayClass
    public let enumerationClass = Class.enumerationClass
    public let addressClass = Class.addressClass
    
    public var nilInstance:Symbol
        {
        if let instance = self.lookup(shortName:"nil")?.first as? Instance
            {
            return(instance)
            }
        fatalError("This should not happen")
        }
        
    public var trueValue:Instance
        {
        return(self.lookup(shortName:"#true")!.first as! Instance)
        }
        
    public var falseValue:Instance
        {
        return(self.lookup(shortName:"#false")!.first as! Instance)
        }
        
    public var voidValue:Instance
        {
        return(self.lookup(shortName:"Void")!.first as! Instance)
        }
        
    internal func initRootModule() -> Self
        {
        self.addSymbol(self.rootClass)
        self.addSymbol(self.addressClass)
        self.addSymbol(self.valueClass)
        self.addSymbol(self.metaClass)
        self.addSymbol(self.classClass)
        self.addSymbol(self.nilClass)
        self.addSymbol(self.voidClass)
        self.addSymbol(self.integerClass)
        self.addSymbol(self.floatClass)
        self.addSymbol(self.uintegerClass)
        self.addSymbol(self.integer64Class)
        self.addSymbol(self.float64Class)
        self.addSymbol(self.uinteger64Class)
        self.addSymbol(self.integer16Class)
        self.addSymbol(self.float16Class)
        self.addSymbol(self.uinteger16Class)
        self.addSymbol(self.integer32Class)
        self.addSymbol(self.float32Class)
        self.addSymbol(self.uinteger32Class)
        self.addSymbol(self.integer8Class)
        self.addSymbol(self.uinteger8Class)
        self.addSymbol(self.stringClass)
        self.addSymbol(self.byteClass)
        self.addSymbol(self.characterClass)
        self.addSymbol(Class.dateClass)
        self.addSymbol(Class.timeClass)
        self.addSymbol(Class.dateTimeClass)
        self.addSymbol(Class.lockClass)
        self.addSymbol(Class.threadClass)
        self.addSymbol(Class.methodClass)
        self.addSymbol(Class.signalClass)
        self.addSymbol(Class.semaphoreClass)
        self.addSymbol(Class.closureClass)
        self.addSymbol(Class.booleanClass)
        self.addSymbol(Class.bitValueClass)
        self.addSymbol(self.uintegerClass)
        self.addSymbol(Class.tupleClass)
        self.addSymbol(Class.moduleClass)
        self.initInstances()
        return(self)
        }
        
    @discardableResult
    public func initInstances() -> Self
        {
        self.makeInstance(of:self.voidClass,named:"Void")
        self.makeInstance(of:self.booleanClass,named:"#true")
        self.makeInstance(of:self.booleanClass,named:"#false")
        self.makeInstance(of:self.addressClass,named:"__handlerBaseAddress")
        let nilInstance = self.nilClass.instanciate()
        nilInstance.shortName = "nil"
        self.addSymbol(nilInstance)
        return(self)
        }
        
    @discardableResult
    private func makeInstance(of ofClass:Class,named:String,metaClass:Instance.Type = Instance.self) -> Instance
        {
        let instance = metaClass.init(class: ofClass)
        instance.shortName = named
        self.addSymbol(instance)
        return(instance)
        }
    }
