//
//  Game.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

class Game {
    
    let world: World = World()
    
    func nextRound() {
        
        var markToDead: [Cell] = []
        var markToAlive: [Cell] = []
        
        for i in 0..<self.world.dimension {
            
            for j in 0..<self.world.dimension {
                
                guard let cell = self.world.getCellFor(x: i, y: j) else { continue }
                
                if isCellWillBeDead(cell: cell) {
                    markToDead.append(cell)
                }
                
                else if isCellWillBeNewBord(cell: cell) {
                    markToAlive.append(cell)
                }

            }
            
        }
        
        markToAlive.forEach { (cell) in
            cell.state = .Alive
        }
        
        markToDead.forEach { (cell) in
            cell.state = .New
        }
    }
    
    func isCellWillBeAlive(cell: Cell) -> Bool {
        let neighbours = world.getLivingNeighboursFor(cell)
        return neighbours.count == 2 || neighbours.count == 3
    }
    
    func isCellWillBeDead(cell: Cell) -> Bool {
        let neighbours = world.getLivingNeighboursFor(cell)
        return neighbours.count < 2 || neighbours.count > 3
    }
    
    func isCellWillBeNewBord(cell: Cell) -> Bool {
        let neighbours = world.getLivingNeighboursFor(cell)
        return neighbours.count == 3
    }
    

}
