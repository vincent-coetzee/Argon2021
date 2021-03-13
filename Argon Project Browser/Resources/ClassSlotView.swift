//
//  ClassSlotView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/07.
//

import Cocoa

class ClassSlotView: NSView
    {
    @IBOutlet var iconView:NSImageView!
    @IBOutlet var titleView:NSTextField!
    @IBOutlet var classView:NSPopUpButton!
    @IBOutlet var deleteButton:NSButton!
    @IBOutlet var addButton:NSButton!

    public var slot:Slot?
        {
        didSet
            {
            self.iconView.image = slot?.icon
            self.titleView.stringValue = slot!.shortName
            }
        }
    }
