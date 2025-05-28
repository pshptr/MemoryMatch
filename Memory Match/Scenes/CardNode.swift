
import SpriteKit

class CardNode: SKSpriteNode {
    var card: Card
    private var frontTexture: SKTexture
    private let backTexture = SKTexture(imageNamed: "Slot")
    var isFlipping = false

    init(card: Card) {
        self.card = card
        self.frontTexture = SKTexture(imageNamed: card.imageName)
        super.init(texture: backTexture, color: .clear, size: CGSize(width: 90, height: 90))
        name = "card"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func flip() {
        isFlipping = true
        let flip1 = SKAction.scaleX(to: 0, duration: 0.2)
        let change = SKAction.run { self.texture = self.frontTexture }
        let flip2 = SKAction.scaleX(to: 1, duration: 0.2)
        let sequence = SKAction.sequence([flip1, change, flip2])
        run(sequence) {
            self.card.isFlipped = true
            self.isFlipping = false
        }
    }

    func flipBack() {
        isFlipping = true
        let flip1 = SKAction.scaleX(to: 0, duration: 0.2)
        let change = SKAction.run { self.texture = self.backTexture }
        let flip2 = SKAction.scaleX(to: 1, duration: 0.2)
        let sequence = SKAction.sequence([flip1, change, flip2])
        run(sequence) {
            self.card.isFlipped = false
            self.isFlipping = false
        }
    }

    func markMatched() {
        card.isMatched = true
        run(SKAction.fadeAlpha(to: 0.5, duration: 0.2))
    }
}
