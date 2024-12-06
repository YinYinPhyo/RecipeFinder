//
//  SearchResultRecipeVC.swift
//  RecipeFinder
//
//  Created by QSCare on 12/6/24.
//

import UIKit

//class SearchResultRecipeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    var recipes: [Recipe] = []
//    
//    private var collectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // Dimmed background
//        
//        // Set up collection view layout for a single column
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Add padding around the collection
//        
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(ResultRecipeCell.self, forCellWithReuseIdentifier: "ResultRecipeCell")
//        
//        view.addSubview(collectionView)
//        
//        // Add close button to dismiss the pop-up
//        let closeButton = UIButton(type: .system)
//        closeButton.setTitle("Close", for: .normal)
//        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(closeButton)
//        
//        NSLayoutConstraint.activate([
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60), // Optional: avoid overlap with top
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//    }
//    
//    // MARK: - Collection View DataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return recipes.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
//        let recipe = recipes[indexPath.item]
//        cell.configure(with: recipe) // Assuming `ResultRecipeCell` has a configure method to display recipe data
//        return cell
//    }
//    
//    // MARK: - Collection View Flow Layout Delegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width - 20 // Subtracting padding (10 + 10)
//        return CGSize(width: width, height: 250) // Adjust height as needed
//    }
//    
//    // MARK: - Dismissing the Pop-Up
//    @objc func dismissPopup() {
//        dismiss(animated: true, completion: nil)
//    }
//}

import UIKit

class SearchResultRecipeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var recipes: [Recipe] = []
    
    private var collectionView: UICollectionView!
    
    // Variable to track the starting position of the popup view
    private var startingPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // Dimmed background
        
        // Set up collection view layout for a single column
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Add padding around the collection
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ResultRecipeCell.self, forCellWithReuseIdentifier: "ResultRecipeCell")
        
        view.addSubview(collectionView)
        
        // Add close button to dismiss the pop-up
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60), // Optional: avoid overlap with top
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Add pan gesture recognizer for drag functionality
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        // Set the modal presentation style to custom
        modalPresentationStyle = .custom
        transitioningDelegate = self // This enables custom transition animations if needed
    }
    
    // MARK: - Handle Pan Gesture (dragging)
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // Only move the view along the Y-axis
        if gesture.state == .began {
            startingPoint = view.center
        } else if gesture.state == .changed {
            view.center = CGPoint(x: startingPoint.x, y: startingPoint.y + translation.y)
        } else if gesture.state == .ended {
            // Optionally, add logic to dismiss the view if dragged far enough down
            if translation.y > 200 { // Customize threshold for dismissal
                dismissPopup()
            } else {
                // Reset the position if not dragged far enough
                UIView.animate(withDuration: 0.3) {
                    self.view.center = self.startingPoint
                }
            }
        }
    }
    
    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe) // Assuming `ResultRecipeCell` has a configure method to display recipe data
        return cell
    }
    
    // MARK: - Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20 // Subtracting padding (10 + 10)
        return CGSize(width: width, height: 250) // Adjust height as needed
    }
    
    // MARK: - Dismissing the Pop-Up
    @objc func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchResultRecipeVC: UIViewControllerTransitioningDelegate {
    
    // Optional: Provide custom transition if needed (e.g., sliding in from bottom)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismissAnimator()
    }
}

// Example custom presentation animator (optional)
class CustomPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        toView.frame.origin.y = containerView.frame.height
        
        UIView.animate(withDuration: 0.5, animations: {
            toView.frame.origin.y = containerView.frame.height - toView.frame.height
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}

// Example custom dismiss animator (optional)
class CustomDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: 0.5, animations: {
            fromView.frame.origin.y = containerView.frame.height
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}
