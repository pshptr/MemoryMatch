import SpriteKit

class SettingsScene: SKScene {

    private var soundButton: SKSpriteNode!
    private var vibrationButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupButtons()
    }

    private func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "GamePlay_BG")
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.size = frame.size
        bg.zPosition = -1
        addChild(bg)
    }
    
    // buttons UI
    private func setupButtons() {
        
        let soundImage = SettingsManager.shared.isSoundOn ? "Sound" : "MuteSound"
        soundButton = SKSpriteNode(imageNamed: soundImage)
        soundButton.name = "sound"
        soundButton.setScale(0.5)
        soundButton.position = CGPoint(x: frame.midX - 80, y: frame.midY + 20)
        soundButton.zPosition = 1
        addChild(soundButton)

        let vibroImage = SettingsManager.shared.isVibrationOn ? "Vibro" : "NoVibro"
        vibrationButton = SKSpriteNode(imageNamed: vibroImage)
        vibrationButton.name = "vibration"
        vibrationButton.setScale(0.5)
        vibrationButton.position = CGPoint(x: frame.midX + 80, y: frame.midY + 20)
        vibrationButton.zPosition = 1
        addChild(vibrationButton)

        let backButton = SKSpriteNode(imageNamed: "Back")
        backButton.name = "back"
        backButton.setScale(0.5)
        backButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        backButton.zPosition = 1
        addChild(backButton)
    }
    
    // buttons handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self),
              let touchedNode = nodes(at: location).first else { return }

        switch touchedNode.name {
        case "sound":
            SettingsManager.shared.isSoundOn.toggle()
            let newTexture = SKTexture(imageNamed: SettingsManager.shared.isSoundOn ? "Sound" : "MuteSound")
            soundButton.texture = newTexture

        case "vibration":
            SettingsManager.shared.isVibrationOn.toggle()
            let newTexture = SKTexture(imageNamed: SettingsManager.shared.isVibrationOn ? "Vibro" : "NoVibro")
            vibrationButton.texture = newTexture

        case "back":
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: .flipVertical(withDuration: 0.4))

        default:
            break
        }
    }
}
