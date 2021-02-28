//
//  DecoratorPane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Cocoa

public class DecoratorPane:Pane
    {
    private var alignment:Alignment
    private var contentPane:Pane
    
    public var padding:CGFloat = StylePalette.kDefaultPaneEdgePadding
        {
        didSet
            {
            self.layout()
            }
        }
        
    init(pane:Pane,alignment:Alignment = [.left])
        {
        self.alignment = alignment
        self.contentPane = pane
        super.init()
        self.addSublayer(contentPane)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func measure() -> CGSize
        {
        var size = self.contentPane.measure()
        size.width += padding + padding
        size.height += padding + padding
        return(size)
        }
        
    public override func layout()
        {
        self.bounds = NSRect(origin: .zero,size: self.measure())
        self.contentPane.bounds = NSRect(origin:.zero,size: self.contentPane.measure())
        self.contentPane.layout()
        self.contentPane.position = self.bounds.center
        }
    }
