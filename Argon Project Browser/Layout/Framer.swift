//
//  Framer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class Framer<PaneType>:NSView,Framed where PaneType:NSView
    {
    public var contentView:PaneType?
        {
        didSet
            {
            if let view = self.contentView
                {
                self.addSubview(view)
                }
            }
        }
        
    public override var frame:NSRect
        {
        get
            {
            return(super.frame)
            }
        set
            {
            super.frame = newValue
            self.contentView?.frame = self.bounds
            }
        }
        
    public var layoutFrame:LayoutFrame = .sizeToBounds
    
    init(_ contentView:PaneType,inFrame:LayoutFrame = .zero)
        {
        self.layoutFrame = inFrame
        super.init(frame:.zero)
        self.contentView = contentView
        }
    
    public func layout(inView:NSView)
        {
        self.frame = self.layoutFrame.frame(in:inView.bounds)
        if let innerView = self.contentView
            {
            innerView.frame = self.bounds
            }
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

