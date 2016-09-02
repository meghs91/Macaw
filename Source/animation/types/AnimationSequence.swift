
import Foundation

internal class AnimationSequence: BasicAnimation {

	let animations: [BasicAnimation]

	required init(animations: [BasicAnimation]) {
		self.animations = animations

		super.init()

		type = .Sequence
		self.node = animations.first?.node
	}

	override func getDuration() -> Double {
		return animations.map({ $0.getDuration() }).reduce(0, combine: { $0 + $1 })
	}

	public override func stop() {
		animations.forEach { animation in
			animation.stop()
		}
	}

	public override func reverse() -> Animation {
		var reversedAnimations = [BasicAnimation]()
		animations.forEach { animation in
			reversedAnimations.append(animation.reverse() as! BasicAnimation)
		}

		let reversedSequence = reversedAnimations.reverse().sequence() as! BasicAnimation
		reversedSequence.completion = completion
		reversedSequence.progress = progress

		return reversedSequence
	}
}

public extension SequenceType where Generator.Element: Animation {
	public func sequence() -> Animation {

		var sequence = [BasicAnimation]()
		self.forEach { animation in
			sequence.append(animation as! BasicAnimation)
		}
		return AnimationSequence(animations: sequence)
	}
}
