//
//  LabelRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/08.
//

import Cocoa

public class LabelRowWrapper:RowWrapper
    {
    private let label:String
        
    public override var rowHeight:CGFloat
        {
        return(18)
        }
        
    public override func rowView() -> NSView
        {
        return(self.makeLabelView())
        }
        
    private func makeLabelView() -> NSView
        {
        let view = NSTextField(frame:.zero)
        view.stringValue = self.label
        view.isBezeled = false
        view.isEditable = false
        view.textColor = self.primaryColor
        view.font = StylePalette.kDefaultFont
        return(view)
        }
        
    init(label:String)
        {
        self.label = label
        super.init()
        self.primaryColor = .argonCheese
        }
    }

