//
//  ViewController.swift
//  HCCPopup
//
//  Created by Jeff Men on 05/09/2022.
//  Copyright (c) 2022 Jeff Men. All rights reserved.
//

import HCCPopup
import UIKit

class ViewController: UIViewController {
    @IBOutlet var animationLabel: UILabel!
    @IBOutlet var animationReversedSwitch: UISwitch!
    @IBOutlet var animationSegmentedControl: UISegmentedControl!
    @IBOutlet var isDismissibleLabel: UILabel!
    @IBOutlet var isDismissibleSwitch: UISwitch!
    @IBOutlet var alignmentSegmentedControl: UISegmentedControl!
    @IBOutlet var alignmentXLabel: UILabel!
    @IBOutlet var alignmentXSlider: UISlider!
    @IBOutlet var alignmentYLabel: UILabel!
    @IBOutlet var alignmentYSlider: UISlider!
    @IBOutlet var scaleXLabel: UILabel!
    @IBOutlet var scaleXSlider: UISlider!
    @IBOutlet var scaleYLabel: UILabel!
    @IBOutlet var scaleYSlider: UISlider!

    private var isDismissible = false
    private var alignment: Popup.Alignment = .bottomLeft
    private var scaleX: CGFloat = 1
    private var scaleY: CGFloat = 1
    private var animation: Popup.Animation = .reversed(.vertical(duration: 0.3))

    private lazy var popup = Popup()
    private let duration: TimeInterval = 0.3

    @IBAction func valueChanged(_ sender: Any) {
        guard let sender = sender as? UIView else { return }
        switch sender {
        case animationReversedSwitch:
            animationLabel.text = "animation"
            if animationReversedSwitch.isOn {
                animationLabel.text = "animation reversed"
                animation = .reversed(popup.animation)
            } else if case let .reversed(anim) = popup.animation {
                self.animation = anim
            }
        case animationSegmentedControl:
            let reversed = animationReversedSwitch.isOn
            var animation: Popup.Animation
            switch animationSegmentedControl.selectedSegmentIndex {
            case 0:
                animation = reversed ? .reversed(.horizontal(duration: duration)) : .horizontal(duration: duration)
            case 1:
                animation = reversed ? .reversed(.vertical(duration: duration)) : .vertical(duration: duration)
            case 2:
                animation = reversed ? .reversed(.center(duration: duration)) : .center(duration: duration)
            default:
                animation = .custom(duration: duration, transformer: { _ in .init(scaleX: 0.01, y: 0.01).rotated(by: .pi * 3) })
            }
            self.animation = animation
        case isDismissibleSwitch:
            let value = isDismissibleSwitch.isOn
            isDismissibleLabel.text = "isDismissible: \(value)"
            isDismissible = value
        case alignmentSegmentedControl:
            var alignment: Popup.Alignment
            alignmentXLabel.superview?.isHidden = true
            alignmentYLabel.superview?.isHidden = true
            switch alignmentSegmentedControl.selectedSegmentIndex {
            case 0:
                alignment = .topLeft
            case 1:
                alignment = .topRight
            case 2:
                alignment = .bottomLeft
            case 3:
                alignment = .bottomRight
            case 4:
                alignment = .center
            default:
                alignmentXLabel.superview?.isHidden = false
                alignmentYLabel.superview?.isHidden = false
                alignment = .custom(x: -1, y: -1)
            }
            self.alignment = alignment
        case alignmentXSlider:
            let value = alignmentXSlider.value
            if case let .custom(_, y) = popup.alignment {
                alignmentXLabel.text = String(format: "x: %.2f", value)
                self.alignment = .custom(x: Double(value), y: y)
            }
        case alignmentYSlider:
            let value = alignmentYSlider.value
            if case let .custom(x, _) = popup.alignment {
                alignmentYLabel.text = String(format: "y: %.2f", value)
                self.alignment = .custom(x: x, y: Double(value))
            }
        case scaleXSlider:
            let value = scaleXSlider.value
            scaleXLabel.text = String(format: "scaleX: %.2f", value)
            scaleX = CGFloat(value)
        case scaleYSlider:
            let value = scaleYSlider.value
            scaleYLabel.text = String(format: "scaleY: %.2f", value)
            scaleY = CGFloat(value)
        default:
            break
        }
    }

    @IBAction func unwind(segue _: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "HCCPopup0" {
            popup.configuration = .init(isDismissible: isDismissible, alignment: alignment, scaleX: scaleX, scaleY: scaleY, animation: animation)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = popup
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
