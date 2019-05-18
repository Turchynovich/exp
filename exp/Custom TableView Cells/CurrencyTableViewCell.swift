import UIKit

class CurrencyTableViewCell: UITableViewCell {
    var nameLabel: UILabel!
    var currency: UILabel!
    var label: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRect(x: 19, y: 20, width: 190, height: 19))
        nameLabel.font = UIFont(name: "GothamPro-Medium", size: 18)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        
        currency = UILabel(frame: CGRect(x: 162, y: 21, width: 180, height: 18))
        currency.font = UIFont(name: "GothamPro-Medium", size: 18)
        currency.textColor = UIColor(white: 1, alpha: 0.4391)
        currency.textAlignment = .right
        contentView.addSubview(currency)
        
        let image = UIImageView(frame: CGRect(x: 351, y: 23, width: 6, height: 10))
        image.image = UIImage(named: "Shape")
        contentView.addSubview(image)
        
        label = UILabel(frame: CGRect(x: 82, y: 20, width: 190, height: 19))
        label.font = UIFont(name: "GothamPro-Medium", size: 18)
        label.textColor = UIColor.white
        //label.text = " + Add currency"
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
