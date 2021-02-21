//
//  AssociationClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class AssociationClass:Class
    {
    private let keyClass:Class
    private let valueClass:Class
    
    init(keyClass:Class,valueClass:Class)
        {
        self.keyClass = keyClass
        self.valueClass = valueClass
        super.init(shortName:"ASSOCIATION")
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
