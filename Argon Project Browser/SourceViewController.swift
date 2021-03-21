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
    
    public var source:String
        {
        get
            {
            return(sourceView.source)
            }
        set
            {
            self.sourceView.source = newValue
            }
        }
        
    override func viewDidLoad()
        {
        super.viewDidLoad()
        ArgonBrowserViewController.instance?.sourceViewController = self
        self.sourceView.gutterForegroundColor = .white
        self.sourceView.gutterBackgroundColor = .black
        self.sourceView.backgroundColor = .black
        }
        
    func setElemental(_ elemental: Elemental)
        {
        self.elemental = elemental
        if elemental.hasSource
            {
            self.sourceView.source = elemental.source
            if elemental is ArgonFile
                {
                let file = elemental as! ArgonFile
                if file.hasErrors
                    {
                    let annotations = file.errorAnnotations
                    for annotation in annotations
                        {
                        self.sourceView.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
