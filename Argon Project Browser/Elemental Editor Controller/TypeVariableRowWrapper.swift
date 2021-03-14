//
//  TypeVariableRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/08.
//

import Cocoa

public class TypeVariableModel
    {
    private let typeVariable:TypeVariable
    
    dynamic public var typeVariableName:String = ""
    dynamic private var constraintClassName:String = ""
    dynamic private var relationshipName:String = ""
    
    init(typeVariable:TypeVariable)
        {
        self.typeVariable = typeVariable
        self.typeVariableName = typeVariable.shortName
        }
    }
    
public class TypeVariableRowWrapper:RowWrapper
    {
    private let typeVariable:TypeVariable
    private var children:Array<RowWrapper> = []
    private var model:TypeVariableModel
    
    private func makeChildren()
        {
        let label = FieldRowWrapper<TypeVariableModel,String>(kind: .text, model: self.model, keypath: \TypeVariableModel.typeVariableName)
        let whereLabel = LabelRowWrapper(label:"WHERE")
        let constraintName = FieldRowWrapper<TypeVariableModel,String>(kind: .text, model: self.model, keypath: \TypeVariableModel.typeVariableName)
        let relationship = FieldRowWrapper<TypeVariableModel,String>(kind: .popup, model: self.model, keypath: \TypeVariableModel.typeVariableName, titles: self.allRelationshipNames())
        let className = FieldRowWrapper<TypeVariableModel,String>(kind: .popup, model: self.model, keypath: \TypeVariableModel.typeVariableName, hasTrashButton:true, hasAddButton:true, titles: self.allClassNames())
        self.children.append(label)
        self.children.append(whereLabel)
        self.children.append(constraintName)
        self.children.append(relationship)
        self.children.append(className)
        }
        
    public override var isExpandable:Bool
        {
        return(true)
        }
        
    public override func rowView() -> NSView
        {
        let view = NSTextField(frame:.zero)
        view.isBezeled = false
        view.stringValue = self.typeVariable.shortName
        view.textColor = NSColor.white
        return(view)
        }
        
    public override var count:Int
        {
        return(self.children.count)
        }
        
        
    public override var rowHeight:CGFloat
        {
        return(Self.kRowHeight)
        }
        
    init(typeVariable:TypeVariable)
        {
        self.typeVariable = typeVariable
        self.model = TypeVariableModel(typeVariable:self.typeVariable)
        super.init()
        self.makeChildren()
        }
        
    public override func child(atIndex index:Int) -> RowWrapper
        {
        return(self.children[index])
        }
        
    private func allRelationshipNames() -> Array<String>
        {
        return(["is","is not","subclass of","superclass of"])
        }
        
    private func allClassNames() -> Array<String>
        {
        let rootClass = Module.argonModule.lookupClass(name: Name("Root"))!
        let allSubclasses = rootClass.allSubclasses
        return(allSubclasses.map{$0.completeName}.sorted{$0<$1})
        }
    }
