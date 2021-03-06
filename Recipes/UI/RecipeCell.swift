
import Foundation
import UIKit
import SnapKit
import Kingfisher

class RecipeCell: UITableViewCell {

    private lazy var titleLabel: UILabel = self.createTitleLabel()
    private lazy var ingredients: UILabel = self.createIngredientsLabel()
    private lazy var hasLactose: UILabel = self.hasLactoseLabel()
    private lazy var recipeImage: UIImageView = self.createRecipeImageView()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    func setupUI() {
        backgroundColor = .clear
        clipsToBounds = true
        selectionStyle = .none

        addSubview(recipeImage)
        addSubview(titleLabel)
        addSubview(ingredients)
        addSubview(hasLactose)

        recipeImage.snp.makeConstraints { (make) in
            make.width.top.equalToSuperview().inset(2)
            make.centerX.equalToSuperview()
            make.height.equalTo(250)
        }

        let guide = UILayoutGuide()
        addLayoutGuide(guide)

        guide.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.top)
            make.bottom.equalTo(ingredients.snp.bottom)
    
        }



        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.lessThanOrEqualTo(guide.snp.left)
        }

        ingredients.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel.snp.left)
            make.right.lessThanOrEqualTo(guide.snp.left)
            make.bottom.equalToSuperview().inset(16)
        }

        hasLactose.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(180)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

    func setIngredients(_ ingredients: String) {
        self.ingredients.text = ingredients
        setBackgroundColorBaseInIngredients()
    }
    //Asigna un color a la celda o fila dependiendo en la cadena que conforman los ingredientes
    private func setBackgroundColorBaseInIngredients(){
        
        let colorHash = PFColorHash()

        let color = UIColor(red: (CGFloat)(colorHash.rgb(self.ingredients.text!).r) / 255.0,
                                  green: (CGFloat)(colorHash.rgb(self.ingredients.text!).g) / 255.0,
                                   blue: (CGFloat)(colorHash.rgb(self.ingredients.text!).b) / 255.0,
                                  alpha: 1.0)
        self.backgroundColor = color
    }



    func setHasLactose(_ hasLactose: Bool) {
        self.hasLactose.isHidden = !hasLactose
    }

    func setImage(_ image: URL?) {
        self.recipeImage.kf.indicatorType = .activity
        DispatchQueue.main.async {
            self.recipeImage.kf.setImage(
                with: image,
                placeholder: UIImage(named:"No Image"),
                options: [.transition(ImageTransition.fade(1))]
            )
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()


        self.recipeImage.kf.cancelDownloadTask()
    }
}

// MARK: Initialisers
extension RecipeCell {
    private func createRecipeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "recipeImage"
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.accessibilityIdentifier = "title"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func createIngredientsLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.accessibilityIdentifier = "ingredients"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func hasLactoseLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Has Lactose"
        label.accessibilityIdentifier = "lactose"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1

        let radians: CGFloat = 45 * (CGFloat.pi / 180)
        label.transform = CGAffineTransform(rotationAngle: radians)
            .concatenating(CGAffineTransform(translationX: 48, y: 25))
        return label
    }



}
