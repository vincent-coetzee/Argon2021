//
//  CobaltPackage.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ArgonModule:Module
    {
    private var wasInitialized = false
    
    public override var isArgonModule:Bool
        {
        return(true)
        }
        
    private func initBaseClasses()
        {
        self.addSymbol(Class.rootClass)
        self.addSymbol(Class.objectClass)
        self.addSymbol(Class.addressClass)
        self.addSymbol(Class.valueClass)
        self.addSymbol(Class.metaClass)
        self.addSymbol(Class.classClass)
        self.addSymbol(Class.nilClass)
        self.addSymbol(Class.voidClass)
        self.addSymbol(Class.integerClass)
        self.addSymbol(Class.floatClass)
        self.addSymbol(Class.uIntegerClass)
        self.addSymbol(Class.integer64Class)
        self.addSymbol(Class.float64Class)
        self.addSymbol(Class.uInteger64Class)
        self.addSymbol(Class.integer16Class)
        self.addSymbol(Class.float16Class)
        self.addSymbol(Class.uInteger16Class)
        self.addSymbol(Class.integer32Class)
        self.addSymbol(Class.float32Class)
        self.addSymbol(Class.uInteger32Class)
        self.addSymbol(Class.integer8Class)
        self.addSymbol(Class.uInteger8Class)
        self.addSymbol(Class.stringClass)
        self.addSymbol(Class.byteClass)
        self.addSymbol(Class.characterClass)
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
        self.addSymbol(Class.tupleClass)
        self.addSymbol(Class.moduleClass)
        self.addSymbol(Class.pointerClass)
        self.addSymbol(Class.functionClass)
        self.addSymbol(Class.conduitClass)
        self.addSymbol(Class.keyedConduitClass)
        self.addSymbol(Class.sequentialConduitClass)
        self.addSymbol(Class.constantClass)
        self.addSymbol(Class.enumerationClass)
        self.addSymbol(Class.bitValueClass)
        self.addSymbol(Class.bufferClass)
        self.addSymbol(Class.behaviorClass)
        self.addSymbol(Class.associationClass)
        self.addSymbol(Class.hashedClass)
        self.addSymbol(Class.symbolClass)
        self.addSymbol(Class.wordClass)
        }
        
    public override var fullName:Name
        {
        return(Name("\(Name.kNameSeparator)Argon"))
        }
        
    @discardableResult
    internal func initArgonModule() -> Self
        {
        if self.wasInitialized
            {
            return(self)
            }
        self.wasInitialized = true
        self.symbols = SymbolDictionary()
        self.initBaseModules()
        self.initBaseClasses()
        self.initSystemModules()
        SymbolWalker().walkSymbols(self)
        return(self)
        }
        
    public override var elementals:Elementals
        {
        if self._elementals != nil
            {
            return(self._elementals!)
            }
        let classes = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Class}.filter{($0 as! Class).superclasses.isEmpty}
        let enumerations = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Enumeration}
        let methods = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Method}
        let modules = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Module}
        let someSymbols = (modules + classes + enumerations + methods).sorted{$0.shortName<$1.shortName}
        self._elementals = someSymbols.map{ElementalSymbol(symbol:$0)}
        return(self._elementals!)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        for set in self.symbols.values
            {
            for symbol in set.symbols
                {
                try symbol.allocateAddresses(using: compiler)
                }
            }
        }

    public func initSystemObjects(_ segment:MemorySegment)
        {
        }
        
    private func initBaseModules()
        {
        Module.rootModule.addSymbol(self)
        }
        
    private func initSystemModules()
        {
        self.initBaseObjects()
        self.initCollectionsModule()
        self.initSocketsModule()
        self.initConduitsModule()
        self.initIOModule()
       }
        
    private func initBaseObjects()
        {
        Class.stringClass.addSubclass(Class.symbolClass)
        Class.objectClass.placeholderRawSlot("header", class: Class.wordClass,offset:0).placeholderRawSlot("class", class: Class.classClass,offset:Argon.kWordSizeInBytes)
        Class.classClass.placeholderRawSlot("regularSlotCount", class: Class.integerClass,offset:Argon.kWordSizeInBytes * 2).placeholderRawSlot("classSlotCount", class: Class.integerClass,offset:Argon.kWordSizeInBytes * 3)
        Class.dateClass.placeholderRawSlot("day", class: Class.integerClass,offset:Argon.kWordSizeInBytes * 2).placeholderRawSlot("month", class: Class.integerClass,offset:Argon.kWordSizeInBytes * 3).placeholderRawSlot("year", class: Class.integerClass,offset:Argon.kWordSizeInBytes * 4).placeholderClassSlot("Today",class:.dateClass)
        }
        
    private func initCollectionsModule()
        {
        let collectionsModule = self.placeholderModule("Collections",in: self)
        collectionsModule.addSymbol(Class.collectionClass)
        collectionsModule.addSymbol(Class.arrayClass)
        collectionsModule.addSymbol(Class.listClass)
        collectionsModule.addSymbol(Class.setClass)
        collectionsModule.addSymbol(Class.dictionaryClass)
        collectionsModule.addSymbol(Class.byteArrayClass)
        let indexClass = collectionsModule.placeholderClass("Index",parents:[.valueClass])
        let processionClass = collectionsModule.placeholderClass("Procession",parents:[.valueClass]).placeholderSlot("currentIndex",class:indexClass).placeholderSlot("nextIndex",class:indexClass).placeholderSlot("previousIndex",class:indexClass).placeholderSlot("isLastIndex",class:.booleanClass)
        Class.collectionClass.placeholderSlot("count",class:.integerClass).placeholderSlot("firstIndex",class:indexClass).placeholderSlot("lastIndex",class:indexClass)
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",Class.listClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",Class.arrayClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",Class.setClass, true))
        collectionsModule.placeholderMethodInstance("proceed",processionClass,Parameter("collection",Class.dictionaryClass, true))
        }
        
    private func initIOModule()
        {
        let ioModule = self.placeholderModule("IO",in: self)
        let conduitClass = self.lookupClass(name: Name("Conduits\\Conduit"))!
        ioModule.placeholderMethodInstance("write",.integerClass,Parameter("conduit",conduitClass,false),Parameter("format",.stringClass,true),VariadicParameter("arguments",.rootClass,false))
        }
        
    private func initSocketsModule()
        {
        let socketsModule = self.placeholderModule("Sockets",in: self)
        let ipAddressClass = socketsModule.placeholderClass("IPAddress",parents:[.objectClass])
        socketsModule.placeholderClass("IP4Address",parents:[ipAddressClass])
        socketsModule.placeholderClass("IP6Address",parents:[ipAddressClass])
        let socketClass = socketsModule.placeholderClass("Socket",parents:[.objectClass]).placeholderSlot("handle",class:.integerClass).placeholderSlot("hasData",class:.booleanClass).placeholderSlot("localAddress",class:ipAddressClass).placeholderSlot("remoteAddress",class:ipAddressClass).placeholderSlot("port",class:.uInteger16Class)
        socketClass.placeholderSlot("isConnected",class:.booleanClass).placeholderSlot("flags",class:.uInteger64Class)
        socketsModule.addFunction(toMethodNamed:"connect",name:"connect",libraryName:"Sockets",cName:"_connectSocket",returnClass:.booleanClass,parameters:Parameter("socket",socketClass, true),Parameter("address",Class.addressClass, true),Parameter("port",Class.uInteger16Class, true))
        socketsModule.addFunction(toMethodNamed:"close",name:"close",libraryName:"Sockets",cName:"_closeSocket",returnClass:.booleanClass,parameters:Parameter("socket",socketClass, true))
        let byteArrayClass = self.lookupClass(name: Name("Collections\\ByteArray"))!
        socketsModule.addFunction(toMethodNamed:"read",name:"read",libraryName:"Sockets",cName:"_readSocket",returnClass:byteArrayClass,parameters:Parameter("socket",socketClass, true))
        socketsModule.addFunction(toMethodNamed:"write",name:"write",libraryName:"Sockets",cName:"_writeSocket",returnClass:.integerClass,parameters:Parameter("socket",socketClass, true),Parameter("bytes",byteArrayClass, true))
        }
        
    private func initConduitsModule()
        {
        let conduitsModule = self.placeholderModule("Conduits",in: self)
        let constant = Constant(shortName:"$DefaultPacketSize",class: .integerClass,integer: 128)
        conduitsModule.addSymbol(constant)
        let sink = conduitsModule.placeholderEnumeration("Sink",class: .uIntegerClass).case("#none",value:0).case("#memory",value:1).case("#socket",value:2).case("#file",value:3)
        let conduitMode = conduitsModule.placeholderEnumeration("ConduitMode",class: .uIntegerClass).case("#none",value:0).case("#read",value:1).case("#write",value:2).case("#readwrite",value:3).case("#extend",value:4).case("#text",value:5).case("#raw",value:6)
        let sinksModule = self.placeholderModule("Sinks",in:conduitsModule)
        sinksModule.addSymbol(sink)
        let conduitClass = Class.conduitClass.placeholderSlot("sink",class:sink).placeholderSlot("atEnd",class:.booleanClass).placeholderSlot("count",class:.integerClass)
        conduitsModule.addSymbol(conduitClass)
        conduitClass.placeholderSlot("isReadConduit",class:.booleanClass).placeholderSlot("isWriteConduit",class:.booleanClass).placeholderSlot("isOpen",class:.booleanClass).placeholderSlot("isClosed",class:.booleanClass)
        conduitsModule.placeholderMethodInstance("open",.booleanClass,Parameter("mode", conduitMode, true))
        let readConduit = conduitsModule.placeholderClass("ReadConduit",parents:[conduitClass])
        readConduit.placeholderSlot("isRead",class:.booleanClass)
        let writeConduit = conduitsModule.placeholderClass("WriteConduit",parents:[conduitClass])
        writeConduit.placeholderSlot("isWrite",class:.booleanClass)
        let sinkClass = sinksModule.placeholderClass("Sink",parents:[.objectClass]).placeholderSlot("isSink",class:.booleanClass)
        sinksModule.placeholderClass("Memory",parents:[sinkClass])
        sinksModule.placeholderClass("File",parents:[sinkClass])
        sinksModule.placeholderClass("Socket",parents:[sinkClass])
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
        module.container = .module(searchModule)
        return(module)
        }
        
    public override func lookup(name inputName:Name) -> SymbolSet?
        {
        if let set = self.symbols[inputName.first],let symbolSet = set.lookup(name:inputName.withoutFirst())
            {
            return(symbolSet)
            }
        return(nil)
        }
    }
