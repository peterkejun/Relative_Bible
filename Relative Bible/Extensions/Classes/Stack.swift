//
//  Stack.swift
//  Bible
//
//  Created by Peter Ke on 2019-10-11.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation

class Stack<T> {
    
    var elements: [T] = []
    
    func push(element: T) {
        self.elements.append(element)
    }
    
    func pop() -> T? {
        if self.elements.isEmpty {
            return nil
        }
        return self.elements.removeLast()
    }
    
    func peek() -> T? {
        if self.elements.isEmpty {
            return nil
        }
        return self.elements.last
    }
    
    func clear() {
        self.elements.removeAll()
    }
    
    var isEmpty: Bool {
        return self.elements.isEmpty
    }
    
}
