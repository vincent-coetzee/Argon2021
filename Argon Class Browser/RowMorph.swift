//
//  OutlinerLayer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/06.
//

import Cocoa

public typealias OutlinerChildGenerator = (RowMorph) -> [ArgonMorph]
    
public class RowMorph:ArgonMorph
    {
    let title:String
    let heading:String
    let generator:OutlinerChildGenerator
    var disclosureArrow:DisclosureArrowLayer
    var titleLayer:TextDisplayLayer
    var headingLayer:TextDisplayLayer
    
    init(title:String,heading:String,generator:@escaping OutlinerChildGenerator)
        {
        self.disclosureArrow = DisclosureArrowLayer()
        self.title = title
        self.heading = heading
        self.generator = generator
        self.titleLayer = TextDisplayLayer(string:title,font:ArgonMorph.kLargeFont)
        self.headingLayer = TextDisplayLayer(string:heading,font:ArgonMorph.kMediumFont,horizontalAlignment:.right).textColor(NSColor.white)
        super.init()
        self.headingLayer.resetAttributes()
        self.headingLayer.borderWidth = 2
        self.headingLayer.borderColor = NSColor.orange.cgColor
        self.titleLayer.resetAttributes()
        self.titleLayer.borderWidth = 2
        self.titleLayer.borderColor = NSColor.cyan.cgColor
        self.addSublayer(self.disclosureArrow)
        self.addSublayer(self.titleLayer)
        self.addSublayer(self.headingLayer)
        self.disclosureArrow.layoutFrame = LayoutFrame().layoutDimension(.left(.absolute(2))).layoutDimension(.top(.absolute(2))).layoutDimension(.bottom(.absolute(34))).layoutDimension(.right(.absolute(34)))
        self.titleLayer.layoutFrame = LayoutFrame().layoutDimension(.left(.absolute(40))).layoutDimension(.top(.absolute(2))).layoutDimension(.bottom(.absolute(34))).layoutDimension(.right(.fraction(0.5,0)))
        self.headingLayer.layoutFrame = LayoutFrame().layoutDimension(.left(.fraction(0.5,10))).layoutDimension(.top(.absolute(2))).layoutDimension(.bottom(.absolute(34))).layoutDimension(.right(.fraction(1.0,-10)))
        self.disclosureArrow.action =
            {
            [weak self]
            layer in
            self?.disclose(layer)
            }
        }
        
    override func layout(inFrame aRect:NSRect)
        {
        super.layout(inFrame:aRect)
        self.disclosureArrow.frame = self.disclosureArrow.layoutFrame.rectangle(in: aRect)
        self.titleLayer.frame = self.titleLayer.layoutFrame.rectangle(in: aRect)
        self.headingLayer.frame = self.headingLayer.layoutFrame.rectangle(in: aRect)
        }
        
    private func disclose(_ layer:DisclosureArrowLayer)
        {
        var size = NSSize.zero
        for kid in self.generator(self)
            {
            let estimatedSize = kid.estimatedSize
            size.width = max(size.width,estimatedSize.width)
            size.height = size.height + estimatedSize.height
            }
        }
        
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }
