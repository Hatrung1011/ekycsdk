//
//  LivenessInstructionItemController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource,
    UIPageViewControllerDelegate
{

    var pages: [UIViewController] = []
    var timer: Timer?
    var onPageChanged: ((Int) -> Void)?
    var showPageControl: Bool = true
    var autoNextInterval: TimeInterval? = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        UIPageControl.appearance().currentPageIndicatorTintColor =
            UIColor.frameworkColor(named: "Primary") ?? UIColor.systemBlue
        UIPageControl.appearance().pageIndicatorTintColor =
            UIColor.frameworkColor(named: "Neutral Color600") ?? UIColor.lightGray

        dataSource = self
        self.delegate = self

        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
        //        for subview in self.view.subviews {
        //            if let pageControl = subview as? UIPageControl {
        //                pageControl.isHidden = false
        //                pageControl.currentPageIndicatorTintColor = .primary
        //                pageControl.pageIndicatorTintColor = UIColor(hexString: "#A7ABC3")
        //            }
        //        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startAutoScroll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }

    // Trả về ViewController trước đó
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return self.pages[pages.count - 1]
        }
        return pages[currentIndex - 1]
    }

    // Trả về ViewController kế tiếp
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
            currentIndex < pages.count - 1
        else {
            return self.pages[0]
        }
        return pages[currentIndex + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
        if completed {
            notifyPageChanged()
            self.startAutoScroll()
        }
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        self.stopAutoScroll()
    }

    private func notifyPageChanged() {
        guard let currentVC = viewControllers?.first,
            let index = pages.firstIndex(of: currentVC)
        else { return }
        onPageChanged?(index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard self.showPageControl else { return 0 }
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first,
            let index = pages.firstIndex(of: firstVC)
        else {
            return 0
        }
        return index
    }

    func startAutoScroll() {
        guard let autoNextInterval else {
            return
        }
        self.stopAutoScroll()
        self.timer = Timer.scheduledTimer(withTimeInterval: autoNextInterval, repeats: true) {
            [weak self] timer in
            self?.nextPage()
        }
    }

    func stopAutoScroll() {
        self.timer?.invalidate()
    }

    func nextPage() {
        guard let currentVC = self.viewControllers?.first,
            let nextVC = self.pageViewController(self, viewControllerAfter: currentVC)
        else {
            self.timer?.invalidate()
            return
        }
        self.setViewControllers(
            [nextVC], direction: .forward, animated: true,
            completion: { [weak self] _ in
                self?.notifyPageChanged()
            })
    }
}

class LivenessInstructionItemController: UIViewController {

    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var imgvShould: UIImageView!
    @IBOutlet weak var imgvShouldNot: UIImageView!
    var instruction: String?
    var should: UIImage?
    var shouldNot: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblInstruction.text = self.instruction
        self.imgvShould.image = self.should
        self.imgvShouldNot.image = self.shouldNot
    }
}

extension LivenessInstructionItemController: StoryboardInitialization {
    typealias Element = LivenessInstructionItemController

    static var storyBoard: AppStoryboard = .Main
}
