import SpriteKit
import AVFoundation
import AudioToolbox

class GameScene: SKScene {

    private var cards = [Card]()
    private var cardNodes = [CardNode]()
    private var flippedCards = [CardNode]()
    private var movesCount = 0
    private var moveLabel: SKLabelNode!
    private var timerLabel: SKLabelNode!
    private var gameTimer: Timer?
    private var secondsPassed = 0
    private var isGamePaused = false
    private var timerActionKey = "timerAction"

    override func didMove(to view: SKView) {
        backgroundColor = .black

        setupBackground()
        setupHUD()
        setupControlButtons()
        generateCards()
        layoutCards()
        startTimer()
        
//        // quick YouWin screen check
//        self.run(SKAction.wait(forDuration: 0.5)) {
//            self.gameOver()
//        }
    }

    // MARK: - UI Setup

    private func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "GamePlay_BG")
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.zPosition = -2
        bg.size = frame.size
        addChild(bg)
    }

    private func setupHUD() {
        let hudBackground = SKSpriteNode(imageNamed: "MovesTime")
        hudBackground.position = CGPoint(x: frame.midX, y: frame.maxY - 180)
        hudBackground.zPosition = 1
        hudBackground.size = CGSize(width: 400, height: 60)
        addChild(hudBackground)

        moveLabel = SKLabelNode(text: "MOVES: 0")
        moveLabel.fontName = "AvenirNext-Bold"
        moveLabel.fontSize = 18
        moveLabel.fontColor = .white
        moveLabel.position = CGPoint(x: frame.midX - 80, y: frame.maxY - 188)
        moveLabel.zPosition = 2
        addChild(moveLabel)

        timerLabel = SKLabelNode(text: "TIME: 00:00")
        timerLabel.fontName = "AvenirNext-Bold"
        timerLabel.fontSize = 18
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: frame.midX + 80, y: frame.maxY - 188)
        timerLabel.zPosition = 2
        addChild(timerLabel)
    }

    private func setupControlButtons() {
        let settingsButton = SKSpriteNode(imageNamed: "Settings")
        settingsButton.name = "settings"
        settingsButton.setScale(0.5)
        settingsButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 100)
        settingsButton.zPosition = 2
        addChild(settingsButton)

        let pauseButton = SKSpriteNode(imageNamed: "Pause")
        pauseButton.name = "pause"
        pauseButton.setScale(0.5)
        pauseButton.position = CGPoint(x: frame.minX + 90, y: frame.minY + 70)
        pauseButton.zPosition = 2
        addChild(pauseButton)

        let leftButton = SKSpriteNode(imageNamed: "Back")
        leftButton.name = "back"
        leftButton.setScale(0.5)
        leftButton.position = CGPoint(x: frame.midX, y: frame.minY + 70)
        leftButton.zPosition = 2
        addChild(leftButton)

        let restartButton = SKSpriteNode(imageNamed: "Restart")
        restartButton.name = "restart"
        restartButton.setScale(0.5)
        restartButton.position = CGPoint(x: frame.maxX - 90, y: frame.minY + 70)
        restartButton.zPosition = 2
        addChild(restartButton)
    }

    // MARK: - Timer

    func startTimer() {
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run {
            self.secondsPassed += 1
            let minutes = self.secondsPassed / 60
            let seconds = self.secondsPassed % 60
            self.timerLabel.text = String(format: "TIME: %02d:%02d", minutes, seconds)
        }

        let sequence = SKAction.sequence([wait, block])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: timerActionKey)
    }
    
    func pauseTimer() {
        removeAction(forKey: timerActionKey)
    }

    func resumeTimer() {
        startTimer()
    }

    private func stopTimer() {
        gameTimer?.invalidate()
    }

    // MARK: - Cards

    private func generateCards() {
        
        let images = (1...8).map { "Slot\($0)" }
        let allCards = (images + images).shuffled()
        cards = allCards.enumerated().map { index, image in
            Card(id: index, imageName: image)
        }
    }

    private func layoutCards() {
        let rows = 4
        let columns = 4
        let spacing: CGFloat = 15
        let cardSize = CGSize(width: 90, height: 90)
        let totalWidth = CGFloat(columns) * cardSize.width + CGFloat(columns - 1) * spacing
        let totalHeight = CGFloat(rows) * cardSize.height + CGFloat(rows - 1) * spacing

        let startX = frame.midX - totalWidth / 2 + cardSize.width / 2
        let startY = frame.midY + totalHeight / 2 - cardSize.height / 2

        for row in 0..<rows {
            for col in 0..<columns {
                let index = row * columns + col
                let card = cards[index]

                let node = CardNode(card: card)
                let posX = startX + CGFloat(col) * (cardSize.width + spacing)
                let posY = startY - CGFloat(row) * (cardSize.height + spacing)
                node.position = CGPoint(x: posX, y: posY)
                node.zPosition = 3
                node.setScale(1)

                addChild(node)
                cardNodes.append(node)
            }
        }
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self),
              let touchedNode = nodes(at: location).first else { return }

        switch touchedNode.name {
        case "settings":
            let settings = SettingsScene(size: self.size)
            settings.scaleMode = .aspectFill
            view?.presentScene(settings, transition: .flipVertical(withDuration: 0.5))
        case "pause":
            isGamePaused.toggle()

            if isGamePaused {
                pauseTimer()
            } else {
                resumeTimer()
            }

            if let pauseButton = childNode(withName: "pause") as? SKSpriteNode {
                let newTexture = SKTexture(imageNamed: isGamePaused ? "Play" : "Pause")
                pauseButton.texture = newTexture
            }
            return
        case "back":
            let menuScene = MenuScene(size: size)
            menuScene.scaleMode = .aspectFill
            view?.presentScene(menuScene, transition: .flipHorizontal(withDuration: 0.5))
            return
        case "left":
            print("Left tapped")
        default:
            break
        }
        
        // youWin screen buttons handle
        switch touchedNode.name {
        case "restart":
            let newGame = GameScene(size: size)
            newGame.scaleMode = .aspectFill
            view?.presentScene(newGame, transition: .crossFade(withDuration: 0.2))
            return
        case "menu":
            let menu = MenuScene(size: size)
            menu.scaleMode = .aspectFill
            view?.presentScene(menu, transition: .crossFade(withDuration: 0.2))
            return
        default:
            break
        }
        
        if isGamePaused && !(["pause", "play", "menu", "restart", "settings", "back"].contains(touchedNode.name ?? "")) {
            return
        }

        guard let cardNode = touchedNode as? CardNode,
              !cardNode.card.isMatched,
              !cardNode.isFlipping else { return }

        if flippedCards.contains(cardNode) { return }

        cardNode.flip()
        
        if SettingsManager.shared.isSoundOn {
            AudioServicesPlaySystemSound(1104) // system click sound
        }

        if SettingsManager.shared.isVibrationOn {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }

        if SettingsManager.shared.isVibrationOn {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        flippedCards.append(cardNode)

        if flippedCards.count == 2 {
            movesCount += 1
            moveLabel.text = "MOVES: \(movesCount)"
            checkMatch()
        }
    }

    private func checkMatch() {
        let first = flippedCards[0]
        let second = flippedCards[1]

        if first.card.imageName == second.card.imageName {
            first.markMatched()
            second.markMatched()
            flippedCards.removeAll()

            if cardNodes.allSatisfy({ $0.card.isMatched }) {
                gameOver()
            }
        } else {
            run(SKAction.wait(forDuration: 1)) {
                first.flipBack()
                second.flipBack()
                self.flippedCards.removeAll()
            }
        }
    }

    private func gameOver() {
        stopTimer()

        let overlay = SKShapeNode(rectOf: frame.size)
        overlay.position = CGPoint(x: frame.midX, y: frame.midY)
        overlay.fillColor = .black
        overlay.alpha = 0.7
        overlay.zPosition = 100
        addChild(overlay)
        
        let winBackground = SKSpriteNode(imageNamed: "BackgroundWin")
        winBackground.position = CGPoint(x: frame.midX, y: frame.midY + 60)
        winBackground.setScale(0.4)
        winBackground.zPosition = 100.5
        addChild(winBackground)
        
        let board = SKSpriteNode(imageNamed: "DateTimeFrame")
        board.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        board.size = CGSize(width: 380, height: 230)
        board.zPosition = 101
        addChild(board)

        let title = SKSpriteNode(imageNamed: "YouWinImage")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        title.setScale(0.4)
        title.zPosition = 101
        addChild(title)

        let movesLabel = SKLabelNode(text: "MOVES: \(movesCount)")
        movesLabel.fontName = "AvenirNext-Bold"
        movesLabel.fontSize = 18
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: 0, y: 20)
        movesLabel.zPosition = 102
        board.addChild(movesLabel)

        let timeLabel = SKLabelNode(text: String(format: "TIME: %02d:%02d", secondsPassed / 60, secondsPassed % 60))
        timeLabel.fontName = "AvenirNext-Bold"
        timeLabel.fontSize = 18
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: 0, y: -20)
        timeLabel.zPosition = 102
        board.addChild(timeLabel)

        let restartButton = SKSpriteNode(imageNamed: "Restart")
        restartButton.name = "restart"
        restartButton.setScale(0.4)
        restartButton.position = CGPoint(x: frame.midX - 50, y: frame.midY - 200)
        restartButton.zPosition = 105
        addChild(restartButton)

        let menuButton = SKSpriteNode(imageNamed: "Menu")
        menuButton.name = "menu"
        menuButton.setScale(0.4)
        menuButton.position = CGPoint(x: frame.midX + 50, y: frame.midY - 200)
        menuButton.zPosition = 105
        addChild(menuButton)
    }
}
