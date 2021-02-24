//
//  ArgonListViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa
import Combine

public enum Event
    {
    case select(Symbol)
    case deselect
    }
    
public protocol EventSink
    {
    func sendEvent(_ event:Event)
    }
    
class ArgonListViewController: NSViewController
    {
    public var cancellable:AnyCancellable?
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        // Do view setup here.
        }
        
    public func connect(to:AnyCancellable?)
        {
        
        }
    }
