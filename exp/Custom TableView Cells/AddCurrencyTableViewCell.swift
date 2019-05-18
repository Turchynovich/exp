import UIKit

class AddCurrencyTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel(frame: CGRect(x: 82, y: 20, width: 190, height: 19))
        label.font = UIFont(name: "GothamPro-Medium", size: 18)
        label.textColor = UIColor.white
        label.text = " + Add currency"
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
