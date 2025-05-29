
import SpriteKit

class CardNode: SKSpriteNode {
    var card: Card
    private var frontTexture: SKTexture
    private let backTexture = SKTexture(imageNamed: "Slot") // card - Slot.png
    var isFlipping = false

    init(card: Card) {
        self.card = card
        self.frontTexture = SKTexture(imageNamed: card.imageName)
        
        // card size
        super.init(texture: backTexture, color: .clear, size: CGSize(width: 80, height: 80))
        name = "card"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // card flipping fucntion
    func flip() {
        guard !isFlipping else { return }
        isFlipping = true

        let flipHalf = SKAction.scaleX(to: 0.0, duration: 0.15) // flip animation
        let showFront = SKAction.run {
            self.texture = SKTexture(imageNamed: self.card.imageName)
        }
        
        let flipBack = SKAction.scaleX(to: 1.0, duration: 0.15) // flip back animation
        let sequence = SKAction.sequence([flipHalf, showFront, flipBack])

        run(sequence) {
            self.isFlipping = false
        }
    }
    
    // card flip back func
    func flipBack() {
        guard !isFlipping else { return }
        isFlipping = true

        let flipHalf = SKAction.scaleX(to: 0.0, duration: 0.15)
        let showBack = SKAction.run {
            self.texture = SKTexture(imageNamed: "Slot") // when flipped back - show Slot.png
        }
        let flipBack = SKAction.scaleX(to: 1.0, duration: 0.15)
        let sequence = SKAction.sequence([flipHalf, showBack, flipBack])

        run(sequence) {
            self.isFlipping = false
        }
    }

    func markMatched() {
        card.isMatched = true
        run(SKAction.fadeAlpha(to: 0.5, duration: 0.2))
    }
}
