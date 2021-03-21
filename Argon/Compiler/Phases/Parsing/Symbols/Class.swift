//
//  Pattern.swift
//  spark
//
//  Created by Vincent Coetzee on 15/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa

public class Class:Symbol,NSCoding
    {
    public static func ==(lhs:Class,rhs:Class) -> Bool
        {
        return(rhs.shortName == lhs.shortName)
        }
        
    public static let rootClass = SystemPlaceholderClass(shortName:"Root")
    public static let classClass = SystemPlaceholderClass(shortName:"Class").superclass(.rootClass)
    public static let metaClass = SystemPlaceholderClass(shortName:"Metaclass").superclass(.classClass)
    public static let voidClass = SystemPlaceholderClass(shortName:"Void").superclass(.rootClass)
    public static let valueClass = SystemPlaceholderClass(shortName:"Value").superclass(.rootClass)
    public static let constantClass = SystemPlaceholderClass(shortName:"Constant").superclass(.valueClass).becomeValue()
    public static let addressClass = SystemPlaceholderClass(shortName:"Address").superclass(.valueClass).becomeValue()
    public static let objectClass = SystemPlaceholderClass(shortName:"Object").superclass(.rootClass)
    public static let enumerationClass = Class(shortName:"Enumeration").superclass(.valueClass)
    public static let bitValueClass = SystemPlaceholderClass(shortName:"BitValue").superclass(.valueClass).becomeValue()
    public static let nilClass = SystemPlaceholderClass(shortName:"Nil").superclass(.rootClass)
    public static let booleanClass = BooleanClass(shortName:"Boolean").superclass(.valueClass).becomeValue()
    public static let byteClass = ByteClass(shortName:"Byte").superclass(.valueClass).becomeValue()
    public static let characterClass = CharacterClass(shortName:"Character").superclass(.valueClass).becomeValue()
    public static let tupleClass = SystemPlaceholderClass(shortName:"Tuple").superclass(.objectClass)
    public static let bufferClass = SystemPlaceholderClass(shortName:"Buffer").superclass(.objectClass)
    public static let conduitClass = SystemPlaceholderClass(shortName:"Conduit").superclass(.objectClass)
    public static let keyedConduitClass = SystemPlaceholderClass(shortName:"KeyedConduit").superclass(.conduitClass)
    public static let sequentialConduitClass = SystemPlaceholderClass(shortName:"SequentialConduitClass").superclass(.conduitClass)
    public static let dateClass = DateClass(shortName:"Date").superclass(.valueClass)
    public static let timeClass = TimeClass(shortName:"Time").superclass(.valueClass)
    public static let dateTimeClass = DateTimeClass(shortName:"DateTime").superclass(.valueClass)
    public static let signalClass = SystemPlaceholderClass(shortName:"Signal").superclass(.valueClass)
    public static let semaphoreClass = SystemPlaceholderClass(shortName:"Semaphore").superclass(.objectClass)
    public static let moduleClass = SystemPlaceholderClass(shortName:"Module").superclass(.objectClass)
    public static let stringClass = StringClass(shortName:"String").superclass(.valueClass).becomeArray()
    public static let symbolClass = SymbolClass(shortName:"Symbol").superclass(Class.stringClass)
    public static let lockClass = SystemPlaceholderClass(shortName:"Lock").superclass(.valueClass)
    public static let threadClass = SystemPlaceholderClass(shortName:"Thread").superclass(.objectClass)
    public static let behaviorClass = SystemPlaceholderClass(shortName:"Behavior").superclass(.objectClass)
    public static let methodClass = SystemPlaceholderClass(shortName:"Method").superclass(.behaviorClass)
    public static let closureClass = SystemPlaceholderClass(shortName:"Closure").superclass(.behaviorClass)
    public static let functionClass = SystemPlaceholderClass(shortName:"Function").superclass(.behaviorClass)
    public static let integerClass = IntegerClass(shortName:"Integer").superclass(.bitValueClass).becomeValue()
    public static let integer8Class = Integer8Class(shortName:"Integer8").superclass(.bitValueClass).becomeValue()
    public static let integer16Class = Integer16Class(shortName:"Integer16").superclass(.bitValueClass).becomeValue()
    public static let integer32Class = Integer32Class(shortName:"Integer32").superclass(.bitValueClass).becomeValue()
    public static let integer64Class = Integer64Class(shortName:"Integer64").superclass(.bitValueClass).becomeValue()
    public static let uIntegerClass = UIntegerClass(shortName:"UInteger").superclass(.bitValueClass).becomeValue()
    public static let uInteger8Class = UInteger8Class(shortName:"UInteger8").superclass(.bitValueClass).becomeValue()
    public static let uInteger16Class = UInteger16Class(shortName:"UInteger16").superclass(.bitValueClass).becomeValue()
    public static let uInteger32Class = UInteger32Class(shortName:"UInteger32").superclass(.bitValueClass).becomeValue()
    public static let uInteger64Class = UInteger64Class(shortName:"UInteger64").superclass(.bitValueClass).becomeValue()
    public static let wordClass = WordClass(shortName:"Word").superclass(.uInteger64Class).becomeValue()
    public static let floatClass = FloatClass(shortName:"Float").superclass(.bitValueClass).becomeValue()
    public static let float32Class = Float32Class(shortName:"Float32").superclass(.bitValueClass).becomeValue()
    public static let float64Class = Float64Class(shortName:"Float64").superclass(.bitValueClass).becomeValue()
    public static let float16Class = Float16Class(shortName:"Float16").superclass(.bitValueClass).becomeValue()
    public static let hashedClass = SystemPlaceholderClass(shortName:"Hashed").superclass(.objectClass)
    public static let collectionClass = CollectionClass(shortName:"Collection").typeVariable("ELEMENT",.hashedClass).superclass(.objectClass)
    public static let arrayClass = ArrayClass(shortName:"Array").superclass(.collectionClass).typeVariable("ELEMENT").becomeArray().becomeSubscriptable()
    public static let byteArrayClass = ByteArrayClass(shortName:"ByteArray").superclass(.arrayClass).typeVariable("ELEMENT").becomeArray().becomeSubscriptable()
    public static let setClass = SetClass(shortName:"Set").superclass(.collectionClass).typeVariable("ELEMENT").becomeGeneric().genericArity(1)
    public static let listClass = ListClass(shortName:"List").superclass(.collectionClass).typeVariable("ELEMENT").becomeGeneric().genericArity(1)
    public static let bitSetClass = BitSetClass(shortName:"BitSet",keyType:.void,valueType:.void).superclass(.collectionClass)
    public static let associationClass = AssociationClass(shortName:"Association").typeVariable("KEY").typeVariable("VALUE").superclass(.objectClass).becomeGeneric().genericArity(2)
    public static let dictionaryClass = DictionaryClass(shortName:"Dictionary").typeVariable("ELEMENT",.associationClass).superclass(.collectionClass).becomeGeneric().genericArity(1).becomeSubscriptable()
    public static let pointerClass = PointerClass(shortName:"Pointer").superclass(.objectClass).typeVariable("ELEMENT").becomeGeneric().genericArity(1)

    public struct StructureAttributes:OptionSet
        {
        public let rawValue:Int

        public typealias RawValue = Int

        static let opaque = StructureAttributes(rawValue: 1 << 0)
        static let value = StructureAttributes(rawValue: 1 << 1)
        static let `class` = StructureAttributes(rawValue: 1 << 2)
        static let array = StructureAttributes(rawValue: 1 << 3)
        static let generic = StructureAttributes(rawValue: 1 << 4)
        static let subscriptable = StructureAttributes(rawValue: 1 << 5)
        
        public init(rawValue:Int)
            {
            self.rawValue = rawValue
            }
        }
        
    public var isClass:Bool
        {
        return(self.structureAttributes.contains(.class))
        }
        
    public var isValue:Bool
        {
        return(self.structureAttributes.contains(.value))
        }
        
    public var isOpaque:Bool
        {
        return(self.structureAttributes.contains(.opaque))
        }
        
    public var isArray:Bool
        {
        return(self.structureAttributes.contains(.array))
        }
        
    public var isGeneric:Bool
        {
        return(self.structureAttributes.contains(.generic))
        }
        
    public var isSubscriptable:Bool
        {
        return(self.structureAttributes.contains(.subscriptable))
        }
        
    public var displayString:String
        {
        return("$\(self.shortName)")
        }
        
    public var superclasses:Classes = Classes()
        {
        didSet
            {
            for aClass in self.superclasses
                {
                aClass.subclasses.insert(self)
                }
            }
        }
        
    public var allSubclasses:Array<Class>
        {
        var subclasses:Array<Class> = [self]
        for aClass in self.uniqueSubclasses
            {
            subclasses.append(aClass)
            subclasses.append(contentsOf: aClass.allSubclasses)
            }
        return(subclasses.sorted{$0.shortName<$1.shortName})
        }
        
    public var editorCell:ItemEditorCell
        {
        return(ClassEditorCell(class:self))
        }
        
    public override var browserCell:ItemBrowserCell
        {
        return(ItemClassBrowserCell(symbol:self))
        }
        
    public override var completeName:String
        {
        if self.typeVariables.isEmpty
            {
            return(self.fullName.stringName)
            }
        else
            {
            let values = "<" + self.typeVariables.map{$0.shortName}.joined(separator: ",") + ">"
            return(self.fullName.stringName + values)
            }
        }
        
    public var typeVariables:[TypeVariable] = []
    internal var localSlots:[String:Slot] = [:]
    private var allSlots:Array<Slot> = []
    internal var localClassSlots:[String:Slot] = [:]
    private var allClassSlots:Array<Slot> = []
    internal var makers = ClassMakers()
    private  var slotBlockOffsets:[Class:Int] = [:]
    private var wasLaidOut:Bool = false
    public var subclasses = Set<Class>()
    public var indexType:Type.ArrayIndexType?
    public var elementType:Class?
    public var constants:[String:Constant] = [:]
    public var structureAttributes = StructureAttributes()
    public var typeArity:Int = 0
    
    public func copy() -> Class
        {
        let copy = Class(shortName:self.shortName)
        copy.container = self.container
        copy.typeVariables = self.typeVariables
        copy.localSlots = self.localSlots
        copy.localClassSlots = self.localClassSlots
        copy.makers = self.makers
        copy.wasLaidOut = self.wasLaidOut
        copy.subclasses = self.subclasses
        copy.indexType = self.indexType
        copy.elementType = self.elementType
        copy.constants = self.constants
        copy.structureAttributes = self.structureAttributes
        copy.typeArity = self.typeArity
        return(copy)
        }
        
    public var isGenericClass:Bool
        {
        return(!self.typeVariables.isEmpty)
        }
        
    public override var isLeaf: Bool
        {
        return(self.subclasses.count < 1)
        }

    public override var elementals:Elementals
        {
        let classes = self.uniqueSubclasses.items
        let some = classes.sorted{$0.shortName<$1.shortName}.map{ElementalSymbol(symbol:$0)}
        self._elementals = some
        return(self._elementals!)
        }
        
    public override var icon:NSImage
        {
        return(NSImage(named:"IconClass64")!)
        }
        
    private var uniqueSubclasses:OrderedSet<Class>
        {
        let set = OrderedSet<Class>(self.subclasses)
        return(set)
        }
        
    private var uniqueSuperclasses:OrderedSet<Class>
        {
        var set = OrderedSet<Class>(self.superclasses.flatMap{$0.uniqueSuperclasses})
        set.insert(self)
        return(set)
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
        super.init(coder:coder)
        }
        
    @discardableResult
    public func becomeValue() -> Class
        {
        self.structureAttributes.remove(.class)
        self.structureAttributes.insert(.value)
        return(self)
        }
        
    @discardableResult
    public func becomeClass() -> Class
        {
        self.structureAttributes.remove(.value)
        self.structureAttributes.insert(.class)
        return(self)
        }
        
    @discardableResult
    public func becomeOpaque() -> Class
        {
        self.structureAttributes.insert(.opaque)
        return(self)
        }
        
    @discardableResult
    public func becomeArray() -> Class
        {
        self.structureAttributes.insert(.array)
        return(self)
        }
        
    @discardableResult
    public func becomeGeneric() -> Class
        {
        self.structureAttributes.insert(.generic)
        return(self)
        }
        
    @discardableResult
    public func becomeSubscriptable() -> Class
        {
        self.structureAttributes.insert(.subscriptable)
        return(self)
        }
        
    @discardableResult
    public func genericArity(_ arity:Int) -> Class
        {
        self.typeArity = arity
        return(self)
        }
        
    public func instanciateArray(withIndex:Type.ArrayIndexType) -> Class
        {
        let copy:Class = self.copy()
        copy.indexType = withIndex
        return(copy)
        }
        
    public func replaceSlot(_ slot:Slot)
        {
        if slot.isRegularSlot
            {
            self.localSlots[slot.shortName] = slot
            }
        else if slot.isClassSlot
            {
            self.localClassSlots[slot.shortName] = slot
            }
        }
        
    public func replaceConstant(_ slot:Constant)
        {
        self.constants[slot.shortName] = slot
        }
        
    internal override var typeClass:Class
        {
        return(self)
        }
        
    public override func asSymbolContainer() -> SymbolContainer
        {
        return(.class(self))
        }
        
    public func addSubclass(_ aClass:Class)
        {
        aClass.superclasses = aClass.superclasses + [self]
        self.subclasses.insert(aClass)
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
        
    @discardableResult
    internal func superclass(_ parent:Class) -> Class
        {
        self.superclasses.append(parent)
        parent.subclasses.insert(self)
        return(self)
        }
        
    init(shortName:String)
        {
        super.init(shortName:shortName)
        self.memoryAddress = .zero
        }
        
    init(name:Name)
        {
        super.init(name:name)
        self.memoryAddress = .zero
        }
        
    func addRegularSlot(_ slot:Slot)
        {
        self.localSlots[slot.shortName] = slot
        slot.container = .class(self)
        }
        
    func addRawSlot(_ slot:Slot)
        {
        self.localSlots[slot.shortName] = slot
        slot.container = .class(self)
        }
        
    func addClassSlot(_ slot:Slot)
        {
        self.localClassSlots[slot.shortName] = slot
        slot.container = .class(self)
        }
    
    @discardableResult
    func typeVariable(_ name:String,_ constraints:Class...) -> Class
        {
        let typeVariable = TypeVariable(shortName:name,constraints:constraints)
        self.typeVariables.append(typeVariable)
        return(self)
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
        
    func addConstant(_ constant:Constant)
        {
        self.constants[constant.shortName] = constant
        constant.container = .class(self)
        }
        
    func addMaker(_ maker:ClassMaker)
        {
        self.makers.append(maker)
        maker.container = .class(self)
        }
        
    public override func lookup(shortName: String) -> SymbolSet?
        {
        if let slot = self.localClassSlots[shortName]
            {
            return(SymbolSet(slot))
            }
        return(self.container.lookup(shortName:shortName))
        }
        
    @discardableResult
    func superclasses(_ some:[Class]) -> Class
        {
        self.superclasses = some
        for aClass in some
            {
            aClass.subclasses.insert(self)
            }
        return(self)
        }
        
    func allSuperclasses() -> Set<Class>
        {
        var set = Set<Class>()
        for aClass in self.superclasses
            {
            set.insert(aClass)
            for newClass in aClass.allSuperclasses()
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
            slot.container = .class(self)
            }
        for slot in self.localClassSlots.values
            {
            slot.container = .class(self)
            }
        for parent in self.superclasses
            {
            parent.prepareClassForLayout()
            }
        }
        
    @discardableResult
    func placeholderSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.regular]) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:.class(self),attributes: attributes)
        self.addRegularSlot(slot)
        return(self)
        }
        
    @discardableResult
    func placeholderClassSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.class]) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:.class(self),attributes: attributes)
        self.addClassSlot(slot)
        return(self)
        }
        
    @discardableResult
    func placeholderRawSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.raw],offset:Int) -> Class
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:.class(self),attributes: attributes)
        slot.slotOffset = offset
        self.addRawSlot(slot)
        return(self)
        }
        
    public func specialize(with:[Class]) -> Class
        {
        let aClass = Class(shortName:self.shortName)
        aClass.elementType = with[0]
        aClass.subclasses = self.subclasses
        aClass.localSlots = self.localSlots
        return(aClass)
        }
        
    func specialize(indexType:Type.ArrayIndexType,elementType:Class) -> Class
        {
        let aClass = Class(shortName:self.shortName)
        aClass.indexType = indexType
        aClass.elementType = elementType
        aClass.subclasses = self.subclasses
        aClass.localSlots = self.localSlots
        return(aClass)
        }
        
    func specialize(elementType:Class) -> Class
        {
        let aClass = Class(shortName:self.shortName)
        aClass.elementType = elementType
        aClass.subclasses = self.subclasses
        aClass.localSlots = self.localSlots
        return(aClass)
        }
    }

public typealias Classes = Array<Class>





