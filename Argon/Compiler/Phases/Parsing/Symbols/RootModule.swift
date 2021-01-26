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
    
//    public var nilInstance:Symbol
//        {
//        if let instance = self.lookup(shortName:"nil")?.first as? Instance
//            {
//            return(instance)
//            }
//        fatalError("This should not happen")
//        }
        
//    public var trueValue:Instance
//        {
//        return(self.lookup(shortName:"#true")!.first as! Instance)
//        }
//        
//    public var falseValue:Instance
//        {
//        return(self.lookup(shortName:"#false")!.first as! Instance)
//        }
//        
//    public var voidValue:Instance
//        {
//        return(self.lookup(shortName:"Void")!.first as! Instance)
//        }
        
    private func initBaseClasses()
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
        }
        
    internal func initRootModule() -> Self
        {
        self.initBaseClasses()
        self.initInstances()
        self.initSystemModules()
        return(self)
        }
        
    @discardableResult
    public func initInstances() -> Self
        {
//        self.makeInstance(of:self.voidClass,named:"Void")
//        self.makeInstance(of:self.booleanClass,named:"#true")
//        self.makeInstance(of:self.booleanClass,named:"#false")
//        self.makeInstance(of:self.addressClass,named:"__handlerBaseAddress")
//        let nilInstance = self.nilClass.instanciate()
//        nilInstance.shortName = "nil"
//        self.addSymbol(nilInstance)
        return(self)
        }
        
//    @discardableResult
//    private func makeInstance(of ofClass:Class,named:String,metaClass:Instance.Type = Instance.self) -> Instance
//        {
//        fatalErr
//        }
        
    private func initSystemModules()
        {
        self.initCollectionsModule()
        self.initSocketsModule()
        self.initConduitsModule()
        self.initIOModule()
       }
        
    private func initCollectionsModule()
        {
        let collectionsModule = self.placeholderModule("Collections",in: self)
        collectionsModule.addSymbol(Class.arrayClass)
        let indexClass = collectionsModule.placeholderClass("Index",parents:[.valueClass])
        let processionClass = collectionsModule.placeholderClass("Procession",parents:[.valueClass]).placeholderSlot("currentIndex",class:indexClass).placeholderSlot("nextIndex",class:indexClass).placeholderSlot("previousIndex",class:indexClass).placeholderSlot("isLastIndex",class:.booleanClass)
        let collectionClass = collectionsModule.placeholderClass("Collection",parents:[.objectClass]).placeholderSlot("count",class:.integerClass).placeholderSlot("firstIndex",class:indexClass).placeholderSlot("lastIndex",class:indexClass)
        let arrayClass = collectionsModule.placeholderClass("Array",parents:[collectionClass])
        collectionsModule.placeholderClass("ByteArray",parents:[arrayClass])
        let listClass = collectionsModule.placeholderClass("List",parents:[collectionClass])
        let setClass = collectionsModule.placeholderClass("Set",parents:[collectionClass])
        let dictionaryClass = collectionsModule.placeholderClass("Dictionary",parents:[collectionClass])
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",arrayClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",listClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",arrayClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",setClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",dictionaryClass, true))
        }
        
    private func initIOModule()
        {
        let ioModule = self.placeholderModule("IO",in: self)
        let conduitClass = self.lookupClass("Conduits/Conduit")!
        ioModule.placeholderMethodInstance("write",.integerClass,Parameter("conduit",conduitClass,false),Parameter("format",.stringClass,true),VariadicParameter("arguments",.allClass,false))
        }
        
    private func initSocketsModule()
        {
        let socketsModule = self.placeholderModule("Sockets",in: self)
        let ipAddressClass = socketsModule.placeholderClass("IPAddress",parents:[.objectClass])
        socketsModule.placeholderClass("IP4Address",parents:[ipAddressClass])
        socketsModule.placeholderClass("IP6Address",parents:[ipAddressClass])
        let socketClass = socketsModule.placeholderClass("Socket",parents:[.objectClass]).placeholderSlot("handle",class:.integerClass).placeholderSlot("hasData",class:.booleanClass).placeholderSlot("localAddress",class:addressClass).placeholderSlot("remoteAddress",class:addressClass).placeholderSlot("port",class:.uInteger16Class)
        socketClass.placeholderSlot("isConnected",class:.booleanClass).placeholderSlot("flags",class:.uInteger64Class)
        socketsModule.placeholderMethodInstance("connect",.booleanClass,Parameter("socket",socketClass, true),Parameter("address",Class.addressClass, true),Parameter("port",Class.uInteger16Class, true))
        socketsModule.placeholderMethodInstance("close",.booleanClass,Parameter("socket",socketClass, true))
        let byteArrayClass = self.lookupClass("Collections/ByteArray")!
        socketsModule.placeholderMethodInstance("read",byteArrayClass,Parameter("socket",socketClass, true))
        socketsModule.placeholderMethodInstance("write",.integerClass,Parameter("socket",socketClass, true),Parameter("buffer",byteArrayClass,true),Parameter("length",.integerClass,true))
        }
        
    private func initConduitsModule()
        {
        let conduitsModule = self.placeholderModule("Conduits",in: self)
        let sinks = conduitsModule.placeholderEnumeration("Sink",class: .uIntegerClass).case("#none",value:0).case("#memory",value:1).case("#socket",value:2).case("#file",value:3)
        let conduitMode = conduitsModule.placeholderEnumeration("ConduitMode",class: .uIntegerClass).case("#none",value:0).case("#read",value:1).case("#write",value:2).case("#readwrite",value:3).case("#extend",value:4).case("#text",value:5).case("#raw",value:6)
        let sinksModule = self.placeholderModule("Sinks",in:conduitsModule)
        let conduitClass = conduitsModule.placeholderClass("Conduit",parents:[.objectClass]).placeholderSlot("sink",class:sinks).placeholderSlot("atEnd",class:.booleanClass).placeholderSlot("count",class:.integerClass)
        conduitClass.placeholderSlot("isReadConduit",class:.booleanClass).placeholderSlot("isWriteConduit",class:.booleanClass).placeholderSlot("isOpen",class:.booleanClass).placeholderSlot("isClosed",class:.booleanClass)
        conduitsModule.placeholderMethodInstance("open",.booleanClass,Parameter("mode", conduitMode, true))
        let readConduit = conduitsModule.placeholderClass("ReadConduit",parents:[conduitClass])
        readConduit.placeholderSlot("isRead",class:.booleanClass)
        let writeConduit = conduitsModule.placeholderClass("WriteConduit",parents:[conduitClass])
        writeConduit.placeholderSlot("isWrite",class:.booleanClass)
        self.placeholderModule("Memory",in:sinksModule)
        self.placeholderModule("File",in:sinksModule)
        self.placeholderModule("Socket",in:sinksModule)
        }
        
    @discardableResult
    private func placeholderModule(_ name:String,in parentModule:Module? = nil) -> Module
        {
        let searchModule = parentModule == nil ? self : parentModule!
        if let oldModule = searchModule.lookup(shortName:name)?.first as? Module
            {
            return(oldModule)
            }
        let module = SystemPlaceholderModule(shortName:name)
        searchModule.addSymbol(module)
        module.parentScope = searchModule
        module.parent = searchModule
        return(module)
        }
    }
