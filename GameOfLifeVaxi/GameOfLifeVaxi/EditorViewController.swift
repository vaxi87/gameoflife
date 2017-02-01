//
//  EditorViewController.swift
//  GameOfLifeVaxi
//
//  Created by Peter Varga on 2017. 02. 01..
//  Copyright © 2017. Peter Varga. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var game: Game!
    var world: World!
    var gameView: UIView!

    var timer: Timer!
    var isPlaying: Bool = false
    var isGameOver: Bool = false

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.game = Game()
        self.world = game.world
        self.world.isInEditMode = true
        
        // Glider
        self.world.getCellFor(x: 4, y: 3)!.state = .Alive
        self.world.getCellFor(x: 5, y: 4)!.state = .Alive
        self.world.getCellFor(x: 3, y: 5)!.state = .Alive
        self.world.getCellFor(x: 4, y: 5)!.state = .Alive
        self.world.getCellFor(x: 5, y: 5)!.state = .Alive
        
        self.gameView = world.getCurrentStateView()
        self.container.addSubview(gameView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playNext))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name("updateView"), object: nil)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
    
    func updateView() {
        self.gameView.removeFromSuperview()
        self.gameView = self.world.getCurrentStateView()
        self.container.addSubview(self.gameView)
    }
    
    func gameover() {
        if isPlaying {
            playButton.setTitle("Generate new", for: .normal)
            timer.invalidate()
        }
        
        let alertController = UIAlertController(title: "Game of life", message: "Game over :(", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        
        self.isGameOver = true
    }

    @IBAction func playButtonClicked(_ sender: Any) {
        
        if isGameOver {
            isGameOver = false
            playButton.setTitle("Auto play", for: .normal)
            return
        }
        
        if isPlaying {
            playButton.setTitle("Auto play", for: .normal)
            timer.invalidate()
        } else {
            playButton.setTitle("Pause", for: .normal)
            
            timer = Timer.init(timeInterval: 0.4, repeats: true, block: { (timer) in
                DispatchQueue.main.async {
                    self.playNext()
                }
            })
            
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            
        }
        
        isPlaying = !isPlaying

        
    }

}
