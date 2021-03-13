//
//  DetailEditorViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/01.
//

import Cocoa

class ElementalEditorViewController: NSViewController,ElementalSink
    {
    @IBOutlet var detailContainerView:NSView!
    
    public var sink:ElementalSink? = nil
    private var editorCell:ItemEditorCell?
    private var outliner:OutlinerViewController?
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.detailContainerView.wantsLayer = true
        self.detailContainerView.layer?.backgroundColor = NSColor.black.cgColor
        }
    
    internal func setElemental(_ elemental:Elemental)
        {
        if elemental.isEditable
            {
            self.editorCell?.removeFromSuperview()
//            let editor = elemental.editorCell
//            self.editorCell = editor
//            self.view.addSubview(editor)
//            editor.frame = self.view.bounds
//            editor.reload()
            if elemental.isClass
                {
                self.initClassEditor(elemental.classValue)
                }
            }
        }
        
    private func initClassEditor(_ aClass:Class)
        {
        let supers = aClass.superclasses.map{ClassRowWrapper(class:$0)}
        let superclasses = TitledGroupRowWrapper(title:"Superclasses",children:supers)
        let types = aClass.typeVariables.map{TypeVariableRowWrapper(typeVariable:$0)}
        let typeVariables = TitledGroupRowWrapper(title:"TypeVariables",children:types)
        let someSlots = aClass.localSlots.values.map{SlotKindRowWrapper(slot:$0)}
        let slots = TitledGroupRowWrapper(title:"Slots",children:someSlots)
        self.outliner = OutlinerViewController(rows:[superclasses,typeVariables,slots])
        self.detailContainerView.addSubview(outliner!.view)
        outliner!.view.frame = self.detailContainerView.bounds
        outliner!.view.wantsLayer = true
        outliner!.view.layer?.borderColor = NSColor.argonNeonPink.cgColor
        outliner!.view.layer?.borderWidth = 1
        outliner!.view.layer?.cornerRadius = 10
        }
    }
