//
//  ViewModelType+Protocol.swift
//  Let'sShare
//
//  Created by 박소진 on 2023/11/21.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
