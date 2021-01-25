//
//  Pattern.swift
//  spark
//
//  Created by Vincent Coetzee on 15/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Class:Symbol,ThreeAddress
    {
    public static func ==(lhs:Class,rhs:Class) -> Bool
        {
        return(Swift.type(of:rhs)==Swift.type(of:lhs) && rhs.shortName == lhs.shortName)
        }
        
    public static let rootClass = Class(shortName:"Root")
    public static let classClass = Class(shortName:"Class").superclass(.rootClass)
    public static let metaClass = Class(shortName:"Metaclass").superclass(.classClass)
    public static let allClass = Class(shortName:"All").superclass(.rootClass)
    public static let voidClass = Class(shortName:"Void").superclass(.rootClass)
    public static let valueClass = Class(shortName:"Value").superclass(.rootClass)
    public static let constantClass = ConstantClass(shortName:"Constant").superclass(.valueClass)
    public static let addressClass = AddressClass(shortName:"Address").superclass(.valueClass)
    public static let objectClass = Class(shortName:"Object").superclass(.rootClass)
    public static let enumerationClass = Class(shortName:"Enumeration").superclass(.valueClass)
    public static let bitValueClass = Class(shortName:"BitValue").superclass(.valueClass)
    public static let nilClass = Class(shortName:"Nil").superclass(.rootClass)
    public static let booleanClass = Class(shortName:"Boolean").superclass(.valueClass)
    public static let byteClass = Class(shortName:"Byte").superclass(.valueClass)
    public static let characterClass = Class(shortName:"Character").superclass(.valueClass)
    public static let tupleClass = Class(shortName:"Tuple").superclass(.objectClass)
    public static let conduitClass = Class(shortName:"Conduit").superclass(.objectClass)
    public static let keyedConduitClass = Class(shortName:"KeyedConduit").superclass(.conduitClass)
    public static let sequentialConduitClass = Class(shortName:"SequentialConduitClass").superclass(.conduitClass)
    public static let dateClass = Class(shortName:"Date").superclass(.valueClass)
    public static let timeClass = Class(shortName:"Time").superclass(.valueClass)
    public static let dateTimeClass = Class(shortName:"DateTime").superclass(.valueClass)
    public static let signalClass = Class(shortName:"Signal").superclass(.valueClass)
    public static let semaphoreClass = Class(shortName:"Semaphore").superclass(.objectClass)
    public static let moduleClass = Class(shortName:"Module").superclass(.objectClass)
    public static let stringClass = Class(shortName:"String").superclass(.valueClass)
    public static let symbolClass = Class(shortName:"Symbol").superclass(.stringClass)
    public static let lockClass = Class(shortName:"Lock").superclass(.valueClass)
    public static let threadClass = Class(shortName:"Thread").superclass(.objectClass)
    public static let behaviorClass = Class(shortName:"Behavior").superclass(.objectClass)
    public static let methodClass = Class(shortName:"Method").superclass(.behaviorClass)
    public static let closureClass = Class(shortName:"Closure").superclass(.behaviorClass)
    public static let functionClass = Class(shortName:"Function").superclass(.behaviorClass)
    public static let integerClass = Class(shortName:"Integer").superclass(.bitValueClass)
    public static let integer8Class = Class(shortName:"Integer8").superclass(.bitValueClass)
    public static let integer16Class = Class(shortName:"Integer16").superclass(.bitValueClass)
    public static let integer32Class = Class(shortName:"Integer32").superclass(.bitValueClass)
    public static let integer64Class = Class(shortName:"Integer64").superclass(.bitValueClass)
    public static let uIntegerClass = Class(shortName:"UInteger").superclass(.bitValueClass)
    public static let uInteger8Class = Class(shortName:"UInteger8").superclass(.bitValueClass)
    public static let uInteger16Class = Class(shortName:"UInteger16").superclass(.bitValueClass)
    public static let uInteger32Class = Class(shortName:"UInteger32").superclass(.bitValueClass)
    public static let uInteger64Class = Class(shortName:"UInteger64").superclass(.bitValueClass)
    public static let floatClass = Class(shortName:"Float").superclass(.bitValueClass)
    public static let float32Class = Class(shortName:"Float32").superclass(.bitValueClass)
    public static let float64Class = Class(shortName:"Float64").superclass(.bitValueClass)
    public static let float16Class = Class(shortName:"Float16").superclass(.bitValueClass)
    public static let collectionClass = CollectionClass(shortName:"Collection").superclass(.objectClass).slot(Identifier("count"),.integerClass).slot(Identifier("elementType"),.classClass)
    public static let arrayClass = ArrayClass(shortName:"Array",indexType:.unbounded, elementTypeClass: .voidClass).superclass(.collectionClass)
    public static let setClass = SetClass(shortName:"Set",elementTypeClass:.voidClass).superclass(.collectionClass)
    public static let listClass = ListClass(shortName:"List",elementTypeClass:.voidClass).superclass(.collectionClass)
    public static let bitSetClass = BitSetClass(shortName:"BitSet",keyType:.void,valueType:.void).superclass(.collectionClass)
    public static let dictionaryClass = DictionaryClass(shortName:"Dictionary",keyTypeClass:.voidClass,valueTypeClass:.voidClass).superclass(.collectionClass)
    
//    public static func invocationClass(_ name:String,_ kind:InvocationClass.InvocationType,_ classes:[Class],_ returnClass:Class) -> InvocationClass { InvocationClass(shortName:name,type:kind,argumentClasses:classes,returnClass:returnClass) }
    
    public var displayString:String
        {
        return("$\(self.shortName)")
        }
        
    public override var recordKind:RecordKind
        {
        return(.class)
        }
        
    public var superclasses = Classes()
    internal var generics = GenericClasses()
    internal var regularSlots:[String:Slot] = [:]
    private var regularSlotList = Array<Slot>()
    internal var classSlots:[String:Slot] = [:]
    private var classSlotList = Array<Slot>()
    internal var makers = ClassMakers()
    internal var symbols:[String:Symbol] = [:]
    internal var layoutSlots:[LayoutSlot] = []
    
    public override func write(file: ObjectFile) throws
        {
        try super.write(file:file)
        try file.write(self.superclasses)
        try file.write(self.generics)
        try file.write(self.regularSlots.values)
        try file.write(self.classSlots.values)
        try file.write(self.symbols)
        }
        
    internal var lastRegularSlot:Slot?
        {
        return(self.regularSlotList.last)
        }
        
    internal var isGeneric:Bool
        {
        return(!self.generics.isEmpty)
        }
        
    internal override var typeClass:Class
        {
        return(self)
        }
        
    @discardableResult
    internal func slot(_ name:Identifier,_ class:Class) -> Class
        {
        let slot = Slot(shortName: name, class: `class`, attributes: .readonly)
        self.classSlots[slot.shortName] = slot
        return(self)
        }
        
    internal func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        fatalError("This should not have been called")
        }
        
    internal func slotType(_ slotNames:[String]) -> Type
        {
        if slotNames.count == 0
            {
            return(self.type)
            }
        if let name = slotNames.first,let slot = self.classSlots.values.first(where: {$0.shortName == name})
            {
            return(slot.slotType(Array<String>(slotNames.dropFirst())))
            }
        return(Type.undefined)
        }
        
    internal func slotType(_ slotName:String) -> Type
        {
        if let slot = self.classSlots.values.first(where: {$0.shortName == slotName})
            {
            return(slot.slotType(Array<String>()))
            }
        return(Type.undefined)
        }
        
    internal func superclass(_ parent:Class) -> Class
        {
        self.superclasses.append(parent)
        return(self)
        }
        
    internal func instanciate() -> Instance
        {
        return(Instance(class:self))
        }
        
    init(shortName:String,generics:GenericClasses)
        {
        self.generics = generics
        super.init(shortName:shortName)
        var slot = Slot(name:Name("class"),class:Class.classClass,container:self,attributes: .readonly)
        self.classSlots[slot.shortName] = slot
        slot = Slot(name:Name("superclasses"),class: (Class.arrayClass as! ArrayClass).classWithIndex(Type.ArrayIndexType.unbounded),container:self,attributes:.readonly)
        self.classSlots[slot.shortName] = slot
        }
        
    init(shortName:String)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    init(shortName:String,indexType:Type.ArrayIndexType,elementType:Type)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    init(shortName:String,keyType:Type,valueType:Type)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    init(shortName:String,elementType:Type)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        }
        
    required public init(file:ObjectFile) throws
        {
        try super.init(file:file)
        self.superclasses = try file.readArray(of:Class.self)
        self.generics = try file.readArray(of:GenericClass.self)
        var newSlots = try file.readArray(of:Slot.self)
        for slot in newSlots
            {
            self.regularSlots[slot.shortName] = slot
            }
        newSlots = try file.readArray(of:Slot.self)
        for slot in newSlots
            {
            self.classSlots[slot.shortName] = slot
            }
        for aSymbol in try file.readArray(of:Symbol.self)
            {
            self.symbols[aSymbol.shortName] = aSymbol
            }
        }
        
    func addRegularSlot(_ slot:Slot)
        {
        self.regularSlots[slot.shortName] = slot
        slot.container = self
        slot.symbolAdded(to: self)
        }
        
    func addClassSlot(_ slot:Slot)
        {
        self.classSlots[slot.shortName] = slot
        slot.container = self
        slot.symbolAdded(to: self)
        }
    
    func isSubclass(of superclass:Class) -> Bool
        {
        for parent in self.superclasses
            {
            if superclass == parent
                {
                return(true)
                }
            if parent.isSubclass(of:superclass)
                {
                return(true)
                }
            }
        return(false)
        }
        
    internal override func sourceFileElements() -> [SourceFileElement]
        {
        var elements:[SourceFileElement] = []
        for slot in self.classSlots.values
            {
            elements.append(SourceFileElement(.slot(slot)))
            }
        return(elements)
        }
        
    func appendConstant(_ constant:Constant)
        {
        self.symbols[constant.shortName] = constant
        constant.symbolAdded(to: self)
        }
        
    func appendMaker(_ maker:ClassMaker)
        {
        self.makers.append(maker)
        maker.symbolAdded(to: self)
        }
        
    override func lookup(shortName: String) -> SymbolSet?
        {
        if let slot = self.classSlots[shortName]
            {
            return(SymbolSet(slot))
            }
        return(self.parentScope?.lookup(shortName:shortName))
        }
        
    func sllSuperclasses() -> Set<Class>
        {
        var set = Set<Class>()
        for aClass in self.superclasses
            {
            set.insert(aClass)
            for newClass in aClass.sllSuperclasses()
                {
                set.insert(newClass)
                }
            }
        return(set)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        self.layout()
        }
        
    func layout()
        {
        self.prepareClassForLayout()
        }
        
    private func superSlots() -> [Slot]
        {
        let locals = self.regularSlots.values
        let supers = self.superclasses.reduce(into:[]) {array,parent in array.append(contentsOf:parent.superSlots())}
        return(locals + supers)
        }
        
    func prepareClassForLayout()
        {
        for slot in self.regularSlots.values
            {
            slot.container = self
            }
        for slot in self.classSlots.values
            {
            slot.container = self
            }
        for parent in self.superclasses
            {
            parent.prepareClassForLayout()
            }
        self.regularSlotList = self.regularSlots.values.sorted{$0.slotName<$1.slotName}
        }
        
    @discardableResult
    func placeholderSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.class]) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:self,attributes: attributes)
        self.addRegularSlot(slot)
        return(self)
        }
    }

public typealias Classes = Array<Class>

public class SetClass:CollectionClass
    {
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) -> Class
        {
        return(SetClass(shortName:Argon.nextName("SET"),elementTypeClass:self.elementTypeClass))
        }
    }

public class ListClass:CollectionClass
    {
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) ->Class
        {
        return(ListClass(shortName:Argon.nextName("LIST"),elementTypeClass:self.elementTypeClass))
        }
    }

public class BitSetClass:CollectionClass
    {
    public let keyType:Type
    public let valueType:Type
    
    init(shortName:String,keyType:Type,valueType:Type)
        {
        self.keyType = keyType
        self.valueType = valueType
        super.init(shortName:shortName)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init(file:ObjectFile) throws
        {
        fatalError()
        }
        
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.bitset(keyType:self.keyType,valueType:self.valueType))
        }
    }

public class TupleClass:Class
    {
    let elements:[Class]
    
    init(elements:[Class])
        {
        self.elements = elements
        super.init(shortName:"TUPLE_\(Argon.nextIndex())")
        }
    
    required public init(file:ObjectFile) throws
        {
        self.elements = try file.readArray(of:Class.self)
        try super.init(file:file)
        }
    }

public class ValueClass:Class
    {
    public override var recordKind:RecordKind
        {
        return(.valueClass)
        }
    }
    
public class AddressClass:ValueClass
    {
    }
    
public class ConstantClass:ValueClass
    {
    let _class:Class
    
    override init(shortName:String)
        {
        self._class = .voidClass
        super.init(shortName:shortName)
        }
        
    init(shortName:String,class:Class)
        {
        self._class = `class`
        super.init(shortName:shortName)
        }
        
    required init(file:ObjectFile) throws
        {
        self._class = try file.readObject() as! Class
        try super.init(file:file)
        }
    }

public class SequenceGeneratorClass:Class
    {
    let baseClass:Class
    let start:Expression
    let end:Expression
    let step:Expression
    
    init(baseClass:Class,start:Expression,step:Expression,end:Expression)
        {
        self.baseClass = baseClass
        self.start = start
        self.step = step
        self.end = end
        super.init(shortName:Argon.nextName("SEQUENCE"))
        }
        
    public required init(file:ObjectFile) throws
        {
        fatalError()
        }
    }
