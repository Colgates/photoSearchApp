//
//  DetailViewController.swift
//  PhotoSearchApp
//
//  Created by Evgenii Kolgin on 11.07.2021.
//

import SDWebImage
import UIKit

class DetailViewController: UITabBarController {
    
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var imageURL = ""
    var initialCenter = CGPoint()  // The initial center point of the view.

    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageView()
    }
    
    private func configureImageView() {
        view.addSubview(photoView)
        photoView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        photoView.center = view.center
        
        photoView.sd_setImage(with: URL(string: imageURL), completed: nil)
        
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        photoView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture)))
        
    }
    
    @objc private func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {        
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
           // Save the view's original position.
           self.initialCenter = piece.center
        }
           // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
           // Add the X and Y translation to the view's original position.
           let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
           piece.center = newCenter
        }
        else {
           // On cancellation, return the piece to its original location.
           piece.center = initialCenter
        }
    }
    
    @objc private func handlePinchGesture(gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }
    }
}
