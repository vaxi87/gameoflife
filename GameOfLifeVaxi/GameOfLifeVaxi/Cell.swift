//
//  Cell.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

enum State {
    case Alive, MarkToDead, New
}

class Cell {
    
    let x: Int
    let y: Int
    var state: State
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.state = .New
    }

}
