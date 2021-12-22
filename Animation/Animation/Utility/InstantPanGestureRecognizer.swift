//
//  InstantPanGestureRecognizer.swift
//  Animation
//
//  Created by Enes Urkan on 22.12.2021.
//

import UIKit

final class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
