//
//  TextDisplayLayer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/06.
//

import Cocoa

public class TextDisplayLayer:ArgonMorph
    {
    let font:NSFont
    let attributedString:NSAttributedString
    let horizontalAlignment:HorizontalAlignment
    let verticalAlignment:VerticalAlignment
    let textLayer = CATextLayer()
    
    init(string:String,font:NSFont,horizontalAlignment:HorizontalAlignment = .left,verticalAlignment:VerticalAlignment = .top)
        {
        self.font = font
        let attributes:[NSAttributedString.Key:Any] = [.font:font,.foregroundColor:ArgonMorph.kTextColor,.backgroundColor:ArgonMorph.kBackgroundColor]
        self.attributedString = NSAttributedString(string:string,attributes:attributes)
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        super.init()
        self.addSublayer(textLayer)
        self.textLayer.string = string
        self.textLayer.foregroundColor = ArgonMorph.kTextColor
        self.textLayer.backgroundColor = ArgonMorph.kBackgroundColor
        self.textLayer.font = font
        self.textLayer.fontSize = self.font.pointSize
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    public override func layoutSublayers()
        {
        super.layoutSublayers()
        let size = self.attributedString.size()
        let textSize = NSSize(width:ceil(size.width),height:ceil(size.height))
        let (left,top) = calculateTextOffsets(withSize:textSize)
        self.textLayer.frame = CGRect(x: left, y: top, width: textSize.width, height: textSize.height)
        }
        
    public func textColor(_ color:NSColor) -> Self
        {
        self.textLayer.foregroundColor = color.cgColor
        return(self)
        }
        
    private func calculateTextOffsets(withSize size:NSSize) -> (CGFloat,CGFloat)
        {
        let frame = self.bounds
        var x:CGFloat = 0
        var y:CGFloat = 0
        switch(self.horizontalAlignment)
            {
            case .left:
                x = 4
            case .middle:
                x = (frame.size.width - size.width) / 2
            case .right:
                x = frame.size.width - size.width
            case .justify:
                x = 4
            }
        switch(self.verticalAlignment)
            {
            case .top:
                y = 4
            case .middle:
                y = (frame.size.height - size.height) / 2
            case .bottom:
                y = frame.size.height - size.height
            }
        return(x,y)
        }
    }
