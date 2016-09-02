
import RxSwift

internal class OpacityAnimation: AnimationImpl<Double> {

	convenience init(animatedNode: Node, startValue: Double, finalValue: Double, animationDuration: Double, autostart: Bool = false, fps: UInt = 30) {

		let interpolationFunc = { (t: Double) -> Double in
			return startValue.interpolate(finalValue, progress: t)
		}

		self.init(animatedNode: animatedNode, valueFunc: interpolationFunc, animationDuration: animationDuration, autostart: autostart, fps: fps)
	}

	init(animatedNode: Node, valueFunc: (Double) -> Double, animationDuration: Double, autostart: Bool = false, fps: UInt = 30) {
		super.init(observableValue: animatedNode.opacityVar, valueFunc: valueFunc, animationDuration: animationDuration, fps: fps)
		type = .Opacity
		node = animatedNode

		if autostart {
			self.play()
		}
	}

	public override func reverse() -> Animation {

		let reversedFunc = { (t: Double) -> Double in
			return self.vFunc(1.0 - t)
		}

		let reversedAnimation = OpacityAnimation(animatedNode: node!,
			valueFunc: reversedFunc, animationDuration: duration, fps: logicalFps)
		reversedAnimation.progress = progress
		reversedAnimation.completion = completion

		return reversedAnimation
	}
}

public typealias OpacityAnimationDescription = AnimationDescription<Double>

public extension AnimatableVariable {
	public func animate(desc: OpacityAnimationDescription) {
		guard let node = self.node else {
			return
		}

		let _ = OpacityAnimation(animatedNode: node, valueFunc: desc.valueFunc, animationDuration: desc.duration, autostart: true)
	}

	public func animation(desc: OpacityAnimationDescription) -> Animation {
		guard let node = self.node else {
			return EmptyAnimation(completion: { })
		}

		return OpacityAnimation(animatedNode: node, valueFunc: desc.valueFunc, animationDuration: desc.duration, autostart: false)
	}

	public func animate(from from: Double, to: Double, during: Double) {
		self.animate((from >> to).t(during))
	}

	public func animation(from from: Double, to: Double, during: Double) -> Animation {
		return self.animation((from >> to).t(during))
	}

	public func animation(valueFunc valueFrunc: (Double) -> Double, during: Double) -> Animation {
		guard let node = self.node else {
			return EmptyAnimation(completion: { })
		}

		return OpacityAnimation(animatedNode: node, valueFunc: valueFrunc, animationDuration: during)
	}

}