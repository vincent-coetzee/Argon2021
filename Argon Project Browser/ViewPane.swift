//
//  Pane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class ViewPane:NSView,Framed
    {
    public var layoutFrame:LayoutFrame = .zero
    
    public func layout(inView: NSView)
        {
        self.frame = self.layoutFrame.frame(in:inView.bounds)
        }
    }
    
public class TextViewPane:ViewPane
    {
    private let textField = NSTextField(frame:.zero)
    
    public var text:String
        {
        get
            {
            return(self.textField.stringValue)
            }
        set
            {
            self.textField.stringValue = newValue
            }
        }
        
    init(_ text:String)
        {
        super.init(frame:.zero)
        self.textField.stringValue = text
        self.textField.textColor = StylePalette.kPrimaryTextColor
        self.textField.font = StylePalette.kDefaultFont
        self.textField.isBordered = false
        self.textField.drawsBackground = false
        self.textField.isBezeled = false
        self.addSubview(self.textField)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout()
        {
        super.layout()
        self.textField.frame = self.bounds
        }
    }

public class IconViewPane:ViewPane
    {
    private let imageField = NSImageView(frame:.zero)
    
    public var icon:NSImage?
        {
        get
            {
            return(self.imageField.image)
            }
        set
            {
            self.imageField.image = newValue
            }
        }
        
    init(_ text:String)
        {
        super.init(frame:.zero)
        self.imageField.image = icon
        self.addSubview(self.imageField)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout()
        {
        super.layout()
        self.imageField.frame = self.bounds
        }
    }

public class ButtonViewPane:ViewPane
    {
    private let buttonField = NSButton(frame:.zero)
    
    public var title:String?
        {
        get
            {
            return(self.buttonField.title)
            }
        set
            {
            self.buttonField.title = newValue ?? ""
            }
        }
        
    public var image:NSImage?
        {
        get
            {
            return(self.buttonField.image)
            }
        set
            {
            self.buttonField.image = newValue
            }
        }
        
    init(_ title:String)
        {
        super.init(frame:.zero)
        self.buttonField.title = title
        self.addSubview(self.buttonField)
        }
        
    init(_ image:NSImage)
        {
        super.init(frame:.zero)
        self.buttonField.image = image
        self.addSubview(self.buttonField)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout()
        {
        super.layout()
        self.buttonField.frame = self.bounds
        }
    }
