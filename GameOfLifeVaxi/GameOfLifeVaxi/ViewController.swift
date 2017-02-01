//
//  ViewController.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    var game: Game!
    var world: World!
    var gameView: UIView!
    var timer: Timer!
    var isPlaying: Bool = false
    var isGameOver: Bool = false
    @IBOutlet weak var playButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.game = Game()
        self.world = game.world
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(playNext))
        self.view.addGestureRecognizer(tap)
        
        // Glider
        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
        self.world.getCellFor(x: 3, y: 5)!.state = .Alive
        self.world.getCellFor(x: 4, y: 5)!.state = .Alive
        self.world.getCellFor(x: 5, y: 5)!.state = .Alive
        
        self.gameView = world.getCurrentStateView()
        self.container.addSubview(gameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func generateNewWorld() {
        
        self.world.reset()
        
        for _ in 0...(self.world.dimension * 2) {
            let x = randLocation(), y = randLocation()
            self.world.getCellFor(x: x, y: y)!.state = .Alive
        }
        
        // Blinker
//        self.world.getCellFor(x: 3, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 3)!.state = .Alive
        
        // Toad
//        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 6, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 3, y: 4)!.state = .Alive
//        self.world.getCellFor(x: 4, y: 4)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
        
//         // Glider
//        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
//        self.world.getCellFor(x: 3, y: 5)!.state = .Alive
//        self.world.getCellFor(x: 4, y: 5)!.state = .Alive
//        self.world.getCellFor(x: 5, y: 5)!.state = .Alive
        
        gameView?.removeFromSuperview()
        self.gameView = world.getCurrentStateView()
        self.container.addSubview(gameView)
    }

    func randLocation () -> Int {
        return Int(arc4random()) % self.world.dimension
    }

    func playNext() {
        let lastHash = self.world.worldHash
        self.game.nextRound()
        self.gameView.removeFromSuperview()
        self.gameView = self.world.getCurrentStateView()
        self.container.addSubview(self.gameView)
        let currentHash = self.world.worldHash
        
        if lastHash == currentHash {
            self.gameover()
        }
    }
    
    func gameover() {
        if self.isPlaying {
            self.playButton.setTitle("Generate new", for: .normal)
            self.timer.invalidate()
        }
        
        self.isPlaying = false
        
        let alertController = UIAlertController(title: "Game of life", message: "Game over :(", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
        self.isGameOver = true
    }


    @IBAction func resetButtonClicked(_ sender: Any) {
        self.generateNewWorld()
        self.isGameOver = false
        self.playButton.setTitle("Auto play", for: .normal)
    }


    @IBAction func playPauseButtonClicked(_ sender: Any) {
        
        if self.isGameOver {
            self.generateNewWorld()
            self.isGameOver = false
            self.playButton.setTitle("Auto play", for: .normal)
            return
        }
        
        if self.isPlaying {
            self.playButton.setTitle("Auto play", for: .normal)
            self.timer.invalidate()
        } else {
            self.playButton.setTitle("Pause", for: .normal)
            
            self.timer = Timer.init(timeInterval: 0.4, repeats: true, block: { (timer) in
                DispatchQueue.main.async {
                    self.playNext()
                }
            })
    
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
      
        }
        
        self.isPlaying = !self.isPlaying
    }
}

