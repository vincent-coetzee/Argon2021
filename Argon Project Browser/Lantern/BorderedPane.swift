//
//  ClippingPane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Foundation

public class BorderedPane:Pane
    {
    private let contentPane:Pane
    
    public var borderStyle:StylePalette.BorderStyle = StylePalette.kDefaultBorderStyle
        {
        didSet
            {
            self.style()
            self.layout()
            }
        }
        
     init(pane:Pane,borderStyle:StylePalette.BorderStyle = StylePalette.kDefaultBorderStyle)
        {
        self.contentPane = pane
        self.borderStyle = borderStyle
        super.init()
        self.addSublayer(pane)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func style()
        {
        self.borderStyle.apply(to:self)
        }
        
    public override func measure() -> CGSize
        {
        return(self.contentPane.measure().expandedBy(self.borderStyle.gutterWidth))
        }

    public override func layout()
        {
        self.contentPane.frame = self.bounds.insetBy(self.borderStyle.gutterWidth)
        self.contentPane.layout()
        self.style()
        }
    }
