//
//  ArgonClassBrowser.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/04.
//

import Cocoa

class ArgonClassBrowser: NSViewController
    {
    @IBOutlet var layerView:ArgonCompositeView!
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        let layer = TextDisplayLayer(string: "Class Browser",font: ArgonMorph.kStandardFont, horizontalAlignment: .left, verticalAlignment: .top)
        layer.layoutFrame = LayoutFrame().layoutDimension(.left(.absolute(10))).layoutDimension(.top(.absolute(10))).layoutDimension(.bottom(.absolute(70))).layoutDimension(.right(.fraction(1,0)))
        self.layerView.addLayer(layer)
        let arrow = DisclosureArrowLayer()
        arrow.layoutFrame = LayoutFrame().layoutDimension(.left(.absolute(10))).layoutDimension(.top(.absolute(70))).layoutDimension(.bottom(.absolute(102))).layoutDimension(.right(.absolute(42)))
        self.layerView.addLayer(arrow)
        let generator =
            {
            (outliner:RowMorph) -> [ArgonMorph]in
            var kids:[ArgonMorph] = []
            kids.append(TestLayer1())
            kids.append(TestLayer3())
            kids.append(TestLayer2())
            kids.append(TestLayer2())
            kids.append(TestLayer3())
            kids.append(TestLayer1())
            return(kids)
            }
        let outliner = RowMorph(title: "TEST", heading: "Heading", generator: generator)
        outliner.layoutFrame = LayoutFrame().layoutDimension(.left(.absolute(10))).layoutDimension(.top(.absolute(70))).layoutDimension(.bottom(.absolute(102))).layoutDimension(.right(.fraction(1,0)))
        self.layerView.addLayer(outliner)
        }
    }


public class TestLayer1:ArgonMorph
    {
    override init()
        {
        super.init()
        let text = TextDisplayLayer(string:"Test1", font: ArgonMorph.kMediumFont, horizontalAlignment:.left, verticalAlignment:.top)
        text.layoutFrame = LayoutFrame().layoutDimension(.left(.fraction(0,20))).layoutDimension(.top(.fraction(0,0))).layoutDimension(.right(.fraction(1,-20))).layoutDimension(.bottom(.fraction(1,0)))
        self.addSublayer(text)
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    override var estimatedSize:NSSize
        {
        return(NSSize(width:400,height:60))
        }
    }

public class TestLayer2:ArgonMorph
    {
    override init()
        {
        super.init()
        let text = TextDisplayLayer(string:"Test Layer 2222", font: ArgonMorph.kMediumFont, horizontalAlignment:.left, verticalAlignment:.top)
        text.layoutFrame = LayoutFrame().layoutDimension(.left(.fraction(0,60))).layoutDimension(.top(.fraction(0,10))).layoutDimension(.right(.fraction(1,-50))).layoutDimension(.bottom(.fraction(1,-5)))
        self.addSublayer(text)
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    override var estimatedSize:NSSize
        {
        return(NSSize(width:200,height:100))
        }
    }

public class TestLayer3:ArgonMorph
    {
    override init()
        {
        super.init()
        let text = TextDisplayLayer(string:"Test #THREE", font: ArgonMorph.kLargeFont, horizontalAlignment:.left, verticalAlignment:.top)
        text.layoutFrame = LayoutFrame().layoutDimension(.left(.fraction(0,0))).layoutDimension(.top(.fraction(0,0))).layoutDimension(.right(.fraction(1,0))).layoutDimension(.bottom(.fraction(1,0)))
        self.addSublayer(text)
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    override var estimatedSize:NSSize
        {
        return(NSSize(width:600,height:130))
        }
    }
