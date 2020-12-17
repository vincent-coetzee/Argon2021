//
//  Pattern.swift
//  spark
//
//  Created by Vincent Coetzee on 15/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Class:Symbol
    {
    internal static let rootClass = Class(shortName:"Root")
    internal static let classClass = Class(shortName:"Class").parentClass(.rootClass)
    internal static let metaClass = Class(shortName:"Metaclass").parentClass(.classClass)
    internal static let instanceClass = Class(shortName:"Instance").parentClass(.rootClass)
    internal static let voidClass = Class(shortName:"Void").parentClass(.rootClass)
    internal static let valueClass = Class(shortName:"Value").parentClass(.rootClass)
    internal static let bitValueClass = Class(shortName:"BitValue").parentClass(.valueClass)
    internal static let nilClass = Class(shortName:"Nil").parentClass(.rootClass)
    internal static let booleanClass = Class(shortName:"Boolean").parentClass(.valueClass)
    internal static let byteClass = Class(shortName:"Byte").parentClass(.valueClass)
    internal static let characterClass = Class(shortName:"Character").parentClass(.valueClass)
    internal static let objectClass = Class(shortName:"Object").parentClass(.instanceClass)
    internal static let tupleClass = Class(shortName:"Tuple").parentClass(.valueClass)
    internal static let dateClass = Class(shortName:"Date").parentClass(.valueClass)
    internal static let timeClass = Class(shortName:"Time").parentClass(.valueClass)
    internal static let dateTimeClass = Class(shortName:"DateTime").parentClass(.valueClass)
    internal static let signalClass = Class(shortName:"Signal").parentClass(.valueClass)
    internal static let semaphoreClass = Class(shortName:"Semaphore").parentClass(.instanceClass)
    internal static let moduleClass = Class(shortName:"Module").parentClass(.instanceClass)
    internal static let stringClass = Class(shortName:"String").parentClass(.instanceClass)
    internal static let symbolClass = Class(shortName:"Symbol").parentClass(.stringClass)
    internal static let lockClass = Class(shortName:"Lock").parentClass(.instanceClass)
    internal static let threadClass = Class(shortName:"Thread").parentClass(.instanceClass)
    internal static let methodClass = Class(shortName:"Method").parentClass(.instanceClass)
    internal static let closureClass = Class(shortName:"Closure").parentClass(.instanceClass)
    internal static let integerClass = Class(shortName:"Integer").parentClass(.bitValueClass)
    internal static let integer8Class = Class(shortName:"Integer8").parentClass(.bitValueClass)
    internal static let integer16Class = Class(shortName:"Integer16").parentClass(.bitValueClass)
    internal static let integer32Class = Class(shortName:"Integer32").parentClass(.bitValueClass)
    internal static let integer64Class = Class(shortName:"Integer64").parentClass(.bitValueClass)
    internal static let uIntegerClass = Class(shortName:"UInteger").parentClass(.bitValueClass)
    internal static let uInteger8Class = Class(shortName:"UInteger8").parentClass(.bitValueClass)
    internal static let uInteger16Class = Class(shortName:"UInteger16").parentClass(.bitValueClass)
    internal static let uInteger32Class = Class(shortName:"UInteger32").parentClass(.bitValueClass)
    internal static let uInteger64Class = Class(shortName:"UInteger64").parentClass(.bitValueClass)
    internal static let floatClass = Class(shortName:"Float").parentClass(.bitValueClass)
    internal static let float32Class = Class(shortName:"Float32").parentClass(.bitValueClass)
    internal static let float64Class = Class(shortName:"Float64").parentClass(.bitValueClass)
    internal static let float16Class = Class(shortName:"Float16").parentClass(.bitValueClass)
    internal static let collectionClass = Class(shortName:"Collection").parentClass(.instanceClass).slot("count",.integer).slot("elementType",.typeClass)
    internal static let arrayClass = ArrayClass(shortName:"Array",indexType:.unbounded,elementType:.void).parentClass(.collectionClass)
    internal static let setClass = SetClass(shortName:"Set",elementType:.void).parentClass(.collectionClass)
    internal static let listClass = ListClass(shortName:"List",elementType:.void).parentClass(.collectionClass)
    internal static let bitSetClass = BitSetClass(shortName:"BitSet",keyType:.void,valueType:.void).parentClass(.collectionClass)
    internal static let dictionaryClass = DictionaryClass(shortName:"Dictionary",keyType:.void,valueType:.void).parentClass(.collectionClass)
    
    var parentClasses:Classes
        {
        get
            {
            self._parentClasses
            }
        set
            {
            self._parentClasses = newValue
            }
        }
        
    internal var _parentClasses = Classes()
    private var _type:Type?
    internal var generics = GenericTypes()
    internal var slots = Slots()
    internal var makers = ClassMakers()
    internal var hollowMethods:[HollowMethod] = []
    
    internal override var type:Type
        {
        if self._type == nil
            {
            self._type = Type.class(self)
            }
        return(self._type!)
        }
        
    @discardableResult
    internal func slot(_ name:String,_ type:Type) -> Class
        {
        let slot = Slot(shortName: name, type: type, attributes: .readonly)
        self.slots.append(slot)
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
        if let name = slotNames.first,let slot = self.slots.first(where: {$0.shortName == name})
            {
            return(slot.slotType(Array<String>(slotNames.dropFirst())))
            }
        return(Type.undefined)
        }
        
    internal func hollowMethod(_ name:String,_ parms:ParameterName...) -> Class
        {
        self.hollowMethods.append(HollowMethod(name,parms))
        return(self)
        }
        
    internal func parentClass(_ parent:Class) -> Class
        {
        self._parentClasses.append(parent)
        self.slot("superclasses",.array(indexType: .unbounded,elementType: Class.classClass.type))
        return(self)
        }
        
    internal func instanciate() -> Instance
        {
        return(Instance(class:self))
        }
        
    init(shortName:String,generics:GenericTypes)
        {
        self.generics = generics
        super.init(shortName:shortName)
        self.slots.append(Slot(shortName:"class",type:.class(RootModule.rootModule.classClass),container:self,attributes: .readonly))
        self.slots.append(Slot(shortName:"superclasses",type:RootModule.rootModule.arrayClass.typeWithIndex(.unbounded),container:self,attributes: .readonly))
        }
        
    init(shortName:String)
        {
        self.generics = GenericTypes()
        super.init(shortName:shortName)
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    func appendSlot(_ slot:Slot)
        {
        self.slots.append(slot)
        }
        
    func appendMaker(_ maker:ClassMaker)
        {
        self.makers.append(maker)
        }
    }

typealias Classes = Array<Class>

internal class CollectionClass:Class
    {
    public let elementType:Type
    
    init(shortName:String,elementType:Type)
        {
        self.elementType = elementType
        super.init(shortName:shortName)
        }
    
    override init(shortName:String)
        {
        self.elementType = .void
        super.init(shortName:shortName)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        fatalError("This should have been overridden")
        }
    }


internal class ArrayClass:CollectionClass
    {
    public let indexType:Type.ArrayIndexType
    
    init(shortName:String,indexType:Type.ArrayIndexType,elementType:Type)
        {
        self.indexType = indexType
        super.init(shortName:shortName,elementType:elementType)
        }
    
    override init(shortName:String)
        {
        self.indexType = .none
        super.init(shortName:shortName)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.array(indexType:type,elementType:self.elementType))
        }
    }

internal class SetClass:CollectionClass
    {
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.set(elementType:self.elementType))
        }
    }

internal class ListClass:CollectionClass
    {
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.list(elementType:self.elementType))
        }
    }

internal class BitSetClass:CollectionClass
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
    
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.bitset(keyType:self.keyType,valueType:self.valueType))
        }
    }

internal class DictionaryClass:CollectionClass
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
    
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        return(Type.dictionary(keyType:self.keyType,valueType:self.valueType))
        }
    }
