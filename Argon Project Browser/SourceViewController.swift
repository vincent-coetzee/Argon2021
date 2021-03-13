//
//  SourceViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/12.
//

import Cocoa

class SourceViewController: NSViewController,ElementalSink
    {
    @IBOutlet var sourceView:ArgonSourceTokenizingTextView!
    
    private var elemental:Elemental?
    
    public var source:String = ""
        {
        didSet
            {
            self.sourceView.source = self.source
            }
        }
        
    override func viewDidLoad()
        {
        super.viewDidLoad()
        ArgonBrowserViewController.instance?.sourceViewController = self
        }
        
    func setElemental(_ elemental: Elemental)
        {
        self.elemental = elemental
        if elemental.hasSource
            {
            self.sourceView.source = elemental.source
            }
        }
    }
