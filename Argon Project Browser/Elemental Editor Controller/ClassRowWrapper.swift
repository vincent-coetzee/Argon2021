//
//  ClassRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/08.
//

import Cocoa

public class ClassRowWrapper:RowWrapper
    {
    private let `class`:Class
        
    public override func rowView() -> NSView
        {
        let view = NSPopUpButton(frame:.zero)
        view.addItems(withTitles: self.allClassNames())
        return(view)
        }
        
    public override var rowHeight:CGFloat
        {
        let font = StylePalette.kDefaultFont
        let attributes:[NSAttributedString.Key:Any] = [.font:font]
        let string = NSAttributedString(string:self.class.completeName,attributes:attributes)
        let size = string.size()
        return(size.height + 4)
        }
        
    init(class:Class)
        {
        self.class = `class`
        }
        
    private func allClassNames() -> Array<String>
        {
        let rootClass = Module.argonModule.lookupClass("Root")!
        let allSubclasses = rootClass.allSubclasses
        return(allSubclasses.map{$0.completeName}.sorted{$0<$1})
        }
    }
