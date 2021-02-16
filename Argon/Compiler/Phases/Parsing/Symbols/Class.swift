//
//  Pattern.swift
//  spark
//
//  Created by Vincent Coetzee on 15/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Class:Symbol,NSCoding
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
    public static let bufferClass = Class(shortName:"Buffer").superclass(.objectClass)
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
    public static let wordClass = Class(shortName:"Word").superclass(.uInteger64Class)
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
        
    public var superclasses = Classes()
    internal var generics = GenericClasses()
    internal var localSlots:[String:Slot] = [:]
    private var allSlots:Array<Slot> = []
    internal var localClassSlots:[String:Slot] = [:]
    private var allClassSlots:Array<Slot> = []
    internal var makers = ClassMakers()
    internal var symbols:[String:Symbol] = [:]
    private  var slotBlockOffsets:[Class:Int] = [:]
    private var wasLaidOut:Bool = false
        
    private var uniqueSuperclasses:OrderedSet<Class>
        {
        if self.shortName == "ClassSuperD"
            {
            print()
            }
        var set = OrderedSet<Class>(self.superclasses.flatMap{$0.uniqueSuperclasses})
        set.insert(self)
        return(set)
        }
        
    public override var sizeInBytes:Int
        {
        var size = 0
        size += Word.kSizeInBytes // class of the class
        size += Word.kSizeInBytes // the name
        size += Word.kSizeInBytes // regular slot count
        size += self.localSlots.values.reduce(0) { total,slot in total + slot.sizeInBytes }
        size += Word.kSizeInBytes // class slot count
        size += self.localClassSlots.values.reduce(0) { total,slot in total + slot.sizeInBytes }
        size += Word.kSizeInBytes // superclasses
        size += Word.kSizeInBytes // generics
        return(size)
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with:coder)
        coder.encode(self.superclasses,forKey:"superclasses")
        coder.encode(self.localSlots,forKey:"localSlots")
        coder.encode(self.localClassSlots,forKey:"classSlots")
//        coder.encode(self.symbols.values,forKey:"symbols")
        }
    
    public required init?(coder: NSCoder)
        {
        self.superclasses = coder.decodeObject(forKey:"superclasses") as! Array<Class>
        self.localSlots = coder.decodeObject(forKey:"localSlots") as! Dictionary<String,Slot>
        self.localClassSlots = coder.decodeObject(forKey:"localClassSlots") as! Dictionary<String,Slot>
        for symbol in coder.decodeObject(forKey:"symbols") as! Array<Symbol>
            {
            self.symbols[symbol.shortName] = symbol
            }
        super.init(coder:coder)
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
    internal func slot(_ name:String,_ class:Class) -> Class
        {
        let slot = Slot(shortName: name, class: `class`, attributes: .readonly)
        self.localClassSlots[slot.shortName] = slot
        return(self)
        }
        
   public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptClass(self)
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
        if let name = slotNames.first,let slot = self.localClassSlots.values.first(where: {$0.shortName == name})
            {
            return(slot.slotType(Array<String>(slotNames.dropFirst())))
            }
        return(Type.undefined)
        }
        
    internal func slotType(_ slotName:String) -> Type
        {
        if let slot = self.localClassSlots.values.first(where: {$0.shortName == slotName})
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
        
    init(shortName:String)
        {
        self.generics = GenericClasses()
        super.init(shortName:shortName)
        self.memoryAddress = Compiler.shared.staticSegment.zero
        }
        
    init(name:Name)
        {
        self.generics = GenericClasses()
        super.init(name:name)
        self.memoryAddress = Compiler.shared.staticSegment.zero
        }
        
    func addRegularSlot(_ slot:Slot)
        {
        self.localSlots[slot.shortName] = slot
        slot.containingSymbol = self
        slot.symbolAdded(to: self)
        }
        
    func addRawSlot(_ slot:Slot)
        {
        self.localSlots[slot.shortName] = slot
        slot.containingSymbol = self
        slot.symbolAdded(to: self)
        }
        
    func addClassSlot(_ slot:Slot)
        {
        self.localClassSlots[slot.shortName] = slot
        slot.containingSymbol = self
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
        for slot in self.localClassSlots.values
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
        if let slot = self.localClassSlots[shortName]
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
        compiler.staticSegment.updateAddress(self)
        }
        
    func layout()
        {
        guard !self.wasLaidOut else
            {
            return
            }
        if self.shortName == "ClassSuperD"
            {
            print("halt")
            }
        self.prepareClassForLayout()
        var copiedSlots = Array<Slot>()
        var offset = 0
        let supers = self.uniqueSuperclasses
        for aClass in supers
            {

            let newSlots = aClass.localSlots.values.map{$0.cloned}
            let slotNames = newSlots.map{$0.shortName}.joined(separator:",")
            print("Class \(aClass.shortName) adding slots \(slotNames)")
            copiedSlots.append(contentsOf:newSlots)
            }
        self.allSlots = copiedSlots
        let names = self.allSlots.map{$0.shortName}.joined(separator:",")
        print("All slots are \(names)")
        for aClass in supers
            {
            self.slotBlockOffsets[aClass] = offset
            let slotNames = aClass.localSlots.values.map{$0.shortName}
            let namedSlots = self.extractNamedSlots(slotNames)
            for slot in namedSlots
                {
                slot.slotOffset = offset
                offset += Argon.kWordSizeInBytes
                }
            }
        for (aClass,anOffset) in self.slotBlockOffsets
            {
            print("Class \(aClass.shortName) offset = \(anOffset)")
            }
        self.wasLaidOut = true
        }
        
    private func extractNamedSlots(_ names:[String]) -> Array<Slot>
        {
        var namedSlots = Array<Slot>()
        let dict = self.allSlots.reduce(into: [String:Slot]()) { dict,slot in dict[slot.shortName] = slot }
        for name in names
            {
            if let slot = dict[name]
                {
                namedSlots.append(slot)
                }
            }
        return(namedSlots)
        }
        
    private func superSlots() -> [Slot]
        {
        let locals = self.localSlots.values
        let supers = self.superclasses.reduce(into:[]) {array,parent in array.append(contentsOf:parent.superSlots())}
        return(locals + supers)
        }
        
    func prepareClassForLayout()
        {
        for slot in self.localSlots.values
            {
            slot.containingSymbol = self
            }
        for slot in self.localClassSlots.values
            {
            slot.containingSymbol = self
            }
        for parent in self.superclasses
            {
            parent.prepareClassForLayout()
            }
        }
        
    @discardableResult
    func placeholderSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.regular]) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:self,attributes: attributes)
        self.addRegularSlot(slot)
        return(self)
        }
        
    @discardableResult
    func placeholderClassSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.class]) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:self,attributes: attributes)
        self.addClassSlot(slot)
        return(self)
        }
        
    @discardableResult
    func placeholderRawSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.raw],offset:Int) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:self,attributes: attributes)
        slot.slotOffset = offset
        self.addRawSlot(slot)
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
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
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
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
}

public class ValueClass:Class
    {
    public override func encode(with coder:NSCoder)
        {
        super.encode(with:coder)
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
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
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
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    }

public class ImportedClassReference:Class
    {
    }
