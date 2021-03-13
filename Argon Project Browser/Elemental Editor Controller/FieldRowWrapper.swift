//
//  FieldRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/08.
//

import Cocoa

public class FieldRowWrapper<Model,FieldType>:RowWrapper
    {
    public enum Kind
        {
        case label
        case text
        case popup
        }
        
    private let model:Model?
    private let keypath:WritableKeyPath<Model,FieldType>?
    private let kind:Kind
    private let hasTrashButton:Bool
    private let hasAddButton:Bool
    private let titles:Array<String>?
    
    public override func rowView() -> NSView
        {
        switch(self.kind)
            {
            case .text:
                return(self.makeTextView())
            case .label:
                return(self.makeLabelView())
            case .popup:
                return(self.makePopupView())
            }
        }
        
    private func makeTextView() -> NSView
        {
        let string = self.model![keyPath:self.keypath!]
        let outerView = OutlinerRowView(frame:.zero)
        let view = NSTextField(frame:.zero)
        let rightOffset:CGFloat = (self.hasTrashButton ? 24 : 0) + (self.hasAddButton ? 24 : 0)
        view.layoutFrame = LayoutFrame(left:0,0,top:0,0,right:1,-rightOffset,bottom:1,0)
        view.isBezeled = false
        view.isEditable = false
        view.textColor = self.primaryColor
        view.font = StylePalette.kDefaultFont
        view.stringValue = string as! String
        outerView.addFramedView(view)
        self.makeButtons(outerView:outerView)
        return(outerView)
        }
        
    private func makeLabelView() -> OutlinerRowView
        {
        let outerView = OutlinerRowView(frame:.zero)
        let view = NSTextField(frame:.zero)
        let rightOffset:CGFloat = (self.hasTrashButton ? 24 : 0) + (self.hasAddButton ? 24 : 0)
        view.layoutFrame = LayoutFrame(left:0,0,top:0,0,right:1,-rightOffset,bottom:1,0)
        view.isBezeled = false
        view.isEditable = false
        view.textColor = self.primaryColor
        view.font = StylePalette.kDefaultFont
        outerView.addFramedView(view)
        self.makeButtons(outerView:outerView)
        return(outerView)
        }
        
    private func makePopupView() -> OutlinerRowView
        {
        let outerView = OutlinerRowView(frame:.zero)
        let view = NSPopUpButton(frame:.zero,pullsDown:false)
        view.addItems(withTitles: self.titles!)
        let rightOffset:CGFloat = (self.hasTrashButton ? 24 : 0) + (self.hasAddButton ? 24 : 0)
        view.layoutFrame = LayoutFrame(left:0,0,top:0,0,right:1,-rightOffset,bottom:1,0)
        view.font = StylePalette.kDefaultFont
        outerView.addFramedView(view)
        self.makeButtons(outerView:outerView)
        return(outerView)
        }
        
    private func makeButtons(outerView:OutlinerRowView)
        {
        var rightOffset:CGFloat = 0
        if self.hasTrashButton
            {
            let trashButton = NSButton(image:NSImage(systemSymbolName: "trash.circle", accessibilityDescription: nil)!,target:self,action:#selector(onTrashClicked))
            trashButton.isBordered = false
            outerView.addFramedView(trashButton)
            trashButton.layoutFrame = LayoutFrame(left:1,-24,top:0,0,right: 1,0,bottom:1,0)
            rightOffset = 24
            }
        if self.hasAddButton
            {
            let addButton = NSButton(image:NSImage(systemSymbolName: "plus.circle", accessibilityDescription: nil)!,target:self,action:#selector(onPlusClicked))
            addButton.isBordered = false
            outerView.addFramedView(addButton)
            addButton.layoutFrame = LayoutFrame(left:1,-rightOffset - 24,top:0,0,right: 1,-rightOffset,bottom:1,0)
            }
        }
        
    @IBAction func onPlusClicked(_ sender:Any?)
        {
        }
        
    @IBAction func onTrashClicked(_ sender:Any?)
        {
        }
        
    public override var rowHeight:CGFloat
        {
        return(24)
        }
        
    init(kind:Kind,model:Model? = nil,keypath:WritableKeyPath<Model,FieldType>? = nil,hasTrashButton:Bool = false,hasAddButton:Bool = false,titles:Array<String>? = nil)
        {
        self.titles = titles
        self.hasAddButton = hasAddButton
        self.hasTrashButton = hasTrashButton
        self.kind = kind
        self.model = model
        self.keypath = keypath
        super.init()
        }
    }
