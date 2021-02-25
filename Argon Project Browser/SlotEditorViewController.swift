//
//  SlotEditorViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class SlotEditorView:NSView
    {
    var imageButton:NSButton = NSButton(frame:.zero)
    var nameField = NSTextField(frame:.zero)
    var classField = NSPopUpButton(frame:.zero)
    
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        self.addSubview(imageButton)
        self.addSubview(nameField)
        self.addSubview(classField)
        self.initFields()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initFields()
        {
        self.imageButton.image = NSImage(named: "trash")!
        self.nameField.isBezeled = false
        self.classField.addItems(withTitles:["Class","Object","Integer","Boolean"])
        }
    }
    
