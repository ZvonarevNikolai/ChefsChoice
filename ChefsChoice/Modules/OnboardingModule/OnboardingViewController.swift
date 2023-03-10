//
//  OnboardingViewController.swift
//  ChefsChoice
//
//  Created by Кащенко on 2.03.23.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let pageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.backgroundStyle = .prominent
        pageControl.allowsContinuousInteraction = false
        
        return pageControl
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    private var pageViews: [UIView] = [
        FirstPageView(), SecondPageView(), ThirdPageView()
    ]
    
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == pageViews.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pageControl.addTarget(self, action: #selector(pageControllDidChange),
                              for: .valueChanged)
        nextButton.addTarget(self, action: #selector(nextButtonPressed),
                             for: .touchUpInside)
        pageScrollView.delegate = self
        addConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePageScrollView()
    }
    
    
    @objc private func pageControllDidChange(_ sender: UIPageControl) {
        let offSetX = view.frame.size.width * CGFloat(pageControl.currentPage)
        pageScrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
    
    @objc func nextButtonPressed() {
        currentPage += 1
        if currentPage >= pageControl.numberOfPages {
            currentPage = 0
        }
        pageControl.currentPage = currentPage
        let offsetX = view.frame.size.width * CGFloat(pageControl.currentPage)
        pageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    private func configurePageScrollView() {
        pageScrollView.contentSize = CGSize(
            width: view.frame.size.width * CGFloat(pageViews.count),
            height: pageScrollView.frame.height)
        pageScrollView.isPagingEnabled = true
        
        for (index, page) in pageViews.enumerated() {
            page.frame = CGRect(
                x: view.frame.origin.x + (view.frame.size.width * CGFloat(index)), y: 0,
                width: pageScrollView.frame.width, height: pageScrollView.frame.height)
            pageScrollView.addSubview(page)
            
        }
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        view.addSubviewWithoutAutoresizingMask(pageControl)
        view.addSubviewWithoutAutoresizingMask(pageScrollView)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(
                equalTo: pageControl.topAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            pageScrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageScrollView.bottomAnchor.constraint(
                equalTo: nextButton.topAnchor),
            pageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(pageScrollView.contentOffset.x / view.frame.size.width)
    }
}




