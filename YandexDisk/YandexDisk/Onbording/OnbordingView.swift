
import UIKit

class OnbordingView: UIView {
    private let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "First")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImage(name: String) {
        image.image = UIImage(named: name)
    }
    
    private func setConstraints() {
        image.snp.makeConstraints { make in
               make.leading.equalToSuperview().offset(100)
               make.trailing.equalToSuperview().offset(-100)
               make.centerY.equalToSuperview()
           }
    }
}
