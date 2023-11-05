
import UIKit
import SnapKit

class OnbordingController: UIViewController {
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var slides = [OnbordingView]()
    
    private let pageControll: UIPageControl = {
       let pageControll = UIPageControl()
        pageControll.numberOfPages = 3
        pageControll.pageIndicatorTintColor = .systemOrange
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        return pageControll
    }()
    
    private let buttonNext: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tabNext), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        setupView()
        setupDelegate()
        setupConstraints()
        
        slides = createSlide()
        setupSlidesScrollView(slides: slides)
    }

    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(pageControll)
        view.addSubview(buttonNext)
    }
    
    private func setupDelegate() {
        scrollView.delegate = self
    }
    
    private func createSlide() -> [OnbordingView] {
        let firstOnbordingView = OnbordingView()
        firstOnbordingView.setImage(name: "First")
        let secondOnbordingView = OnbordingView()
        secondOnbordingView.setImage(name: "Second")
        let thirdOnbordingView = OnbordingView()
        thirdOnbordingView.setImage(name: "Third")
        
        return [firstOnbordingView, secondOnbordingView, thirdOnbordingView]
    }
    
    private func setupSlidesScrollView(slides: [OnbordingView]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        
        for i in 0...slides.count - 1 {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i),
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    @objc func tabNext() {
        let currentPage = pageControll.currentPage
        guard currentPage < slides.count - 1 else {
            let webViewController = WebViewController()
            navigationController?.pushViewController(webViewController, animated: true)
            return
        }
        let nextPage = currentPage + 1
        let nextOfSetX = scrollView.frame.width * CGFloat(nextPage)
        let contentOfSet = CGPoint(x: nextOfSetX, y: 0)
        scrollView.setContentOffset(contentOfSet, animated: true)
        pageControll.currentPage = nextPage
    }
   
    
}

extension OnbordingController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let padeIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControll.currentPage = Int(padeIndex) // при свайпе pageControll меняется
    }
}

extension OnbordingController {
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                pageControll.snp.makeConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
                    make.leading.equalToSuperview().offset(30)
                    make.trailing.equalToSuperview().offset(-30)
                    make.height.equalTo(50)
                }
                
                buttonNext.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(30)
                    make.trailing.equalToSuperview().offset(-30)
                    make.height.equalTo(50)
                    make.width.equalTo(200)
                    make.bottom.equalTo(view.snp.bottom).offset(-200)
                }
    }
}

