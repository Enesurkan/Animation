//
//  DetailViewController.swift
//  Animation
//
//  Created by Enes Urkan on 19.12.2021.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var backgroundImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var track: Track!
    var animationProgress: CGFloat = 0.0
    var animator = UIViewPropertyAnimator()
    
    // MARK: - Lifecycle
    convenience init(track: Track) {
        self.init()
        self.track = track
        setup()
        layout()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DetailViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    // MARK: - Setup
    private func setup() {
        view.backgroundColor = .black
        view.addSubview(backgroundImage)
    }
    
    private func layout() {
        backgroundImage.snp.makeConstraints({$0.edges.equalToSuperview()})
    }
    
    // MARK: - Private Methods
    
    private func prepareView() {
        guard let imageURL = URL(string: self.track.backgroundContent?.sourcePath ?? "") else { return }
        backgroundImage.sd_setImage(with: imageURL, completed: nil)
        
        let recognizer = InstantPanGestureRecognizer(target: self, action: #selector(panRecognizer))
        backgroundImage.addGestureRecognizer(recognizer)
    }
    
    private func startAnimation(){
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            self.view.layer.cornerRadius = 15
        })
        animator.startAnimation()
    }
    
    @objc private func panRecognizer(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: backgroundImage)
        switch recognizer.state{
        case .began:
            self.startAnimation()
            animationProgress = animator.fractionComplete
            animator.pauseAnimation()
        case .changed:
            let fraction = translation.y / 100
            animator.fractionComplete = fraction + animationProgress
            if animator.fractionComplete > 0.99{
                animator.stopAnimation(true)
                dismiss(animated: true, completion: nil)
            }
        case .ended:
            if animator.fractionComplete == 0{
                animator.stopAnimation(true)
                dismiss(animated: true, completion: nil)
            }
            else{
                animator.isReversed = true
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default:
            break
        }
    }
}
