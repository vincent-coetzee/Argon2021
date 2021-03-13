//
//  NullModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/12.
//

import Foundation

public class NullModule:Module
    {
    public static let nullModule = NullModule()
    
    init()
        {
        super.init(shortName:"NullModule")
        self.container = .nothing
        }
    
    public required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }
