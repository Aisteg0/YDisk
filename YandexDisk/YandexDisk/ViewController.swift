
import UIKit
import SnapKit


class ViewController: UIViewController {
    private lazy var buttonEnter: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(openOnbording), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageSkillBox: UIImageView = {
        let image = UIImageView(image: Constants.image)
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
       
    }
    
    private func setupView() {
        view.addSubview(imageSkillBox)
        view.addSubview(buttonEnter)
    }
    private func setupConstraints() {
        imageSkillBox.snp.makeConstraints { make in
            make.width.equalTo(195)
            make.height.equalTo(168)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(270)
        }
        buttonEnter.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(320)
            make.height.equalTo(50)
        }
    }
    
    @objc func openOnbording() {
        let onbordingVC = OnbordingController()
        navigationController?.pushViewController(onbordingVC, animated: true)
    }

}

