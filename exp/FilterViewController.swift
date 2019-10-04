import UIKit

class FilterViewController: UIViewController {
    
    var startDateFilter = NSDate()
    var endDateFilter = NSDate()
    var dataStrFilter = (String(), String())
    var fromButtonBool = true
    var frombuttonDate = NSDate()
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.backgroundColor = UIColor(white: 1, alpha: 0.1)
        fromButton.backgroundColor = UIColor(white: 1, alpha: 0.1)
        toButton.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        datePicker.addTarget(self, action: #selector(FilterViewController.datePickerChange(_:)), for: .valueChanged)
        addDelBorderToButton(add: fromButton, delete: toButton)
        dateButton()
        ovalButton()
    }
    
    @objc func datePickerChange(_ param: UIDatePicker) {
        if param.isEqual(datePicker) {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            if fromButtonBool {
                startDateFilter = calendar.startOfDay(for: param.date) as NSDate
                if let theLabel = self.fromButton.viewWithTag(103) as? UILabel {
                    theLabel.text = dateString1(date: startDateFilter)
                }
            } else {
                endDateFilter = calendar.date(byAdding: .second, value: 86399, to: calendar.startOfDay(for: param.date) as Date)! as NSDate
                if let theLabel1 = self.toButton.viewWithTag(103) as? UILabel {
                    theLabel1.text = dateString1(date: endDateFilter)
                }
            }
        }
    }
    
    static func storyboardInstance() -> FilterViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController
    }
    
    func crossToPaymentCategory(days: Int, str: String) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateNow = calendar.startOfDay(for: Date()) as NSDate
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateNow as Date)! as NSDate
        let dateFrom = calendar.date(byAdding: .day, value: -days, to: dateNow as Date)! as NSDate
        
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        testVC?.startDate = dateFrom
        testVC?.endDate = dateTo
        testVC?.dataStr = (dateString(date: dateFrom) + " - " + dateString1(date: dateTo), str)
        self.present(testVC!, animated: false, completion: nil)
    }
    
    func dateString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.string(from: date as Date)
        return "\(dateFormatter.string(from: date as Date))"
    }
    
    func dateString1(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.string(from: date as Date)
        return "\(dateFormatter.string(from: date as Date))\n"
    }
    
    func addDelBorderToButton(add: UIButton, delete: UIButton) {
        if add.viewWithTag(101) != nil {
            
        } else {
            let lineView = UIView(frame: CGRect(x: 0, y: add.frame.size.height, width: add.frame.size.width, height: 2))
            lineView.tag = 101
            lineView.backgroundColor = UIColor.white
            add.addSubview(lineView)
        }
        
        
        if let viewWithTag = delete.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func dateButton() {
        let labelFromView = UILabel(frame: CGRect(x: 18, y: 12, width: 31, height: 12))
        labelFromView.font = UIFont(name: "GothamPro-Medium", size: 10)
        labelFromView.text = "FROM"
        labelFromView.tag = 102
        labelFromView.textColor = UIColor(white: 1, alpha: 0.45)
        labelFromView.textAlignment = .left
        fromButton.addSubview(labelFromView)
        
        
        let labelDateView = UILabel(frame: CGRect(x: 18, y: 29, width: 100, height: 12))
        labelDateView.font = UIFont(name: "GothamPro-Bold", size: 14)
        labelDateView.text = dateString1(date: NSDate())
        labelDateView.textColor = UIColor.white
        labelDateView.tag = 103
        labelDateView.textAlignment = .left
        fromButton.addSubview(labelDateView)
        
        let labelToView = UILabel(frame: CGRect(x: 0, y: 12, width: 15, height: 12))
        labelToView.font = UIFont(name: "GothamPro-Medium", size: 10)
        labelToView.text = "TO"
        labelToView.tag = 102
        labelToView.textColor = UIColor(white: 1, alpha: 0.45)
        labelToView.textAlignment = .left
        toButton.addSubview(labelToView)
        
        let label2DateView = UILabel(frame: CGRect(x: 0, y: 29, width: 100, height: 12))
        label2DateView.font = UIFont(name: "GothamPro-Bold", size: 14)
        label2DateView.text = dateString1(date: NSDate())
        label2DateView.textColor = UIColor.white
        label2DateView.tag = 103
        label2DateView.textAlignment = .left
        toButton.addSubview(label2DateView)
    }
    
    func ovalButton() {
        
        //cancelButton.layer.borderWidth = 2
        showButton.layer.backgroundColor = UIColor.white.cgColor
        
        cancelButton.clipsToBounds = true
        let path = UIBezierPath(roundedRect: cancelButton.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cancelButton.layer.mask = maskLayer
        
        let path1 = UIBezierPath(roundedRect: cancelButton.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = path1.cgPath
        showButton.layer.mask = maskLayer1
        
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.lineWidth = 4
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = cancelButton.bounds
        cancelButton.layer.addSublayer(borderLayer)
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        testVC?.startDate = startDateFilter
        testVC?.endDate = endDateFilter
        testVC?.dataStr = dataStrFilter
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func lastWeekAction(_ sender: UIButton) {
        crossToPaymentCategory(days: 7, str: "LAST WEEK")
    }
    
    @IBAction func lastMonthAction(_ sender: UIButton) {
        crossToPaymentCategory(days: 30, str: "LAST MONTH")
    }
    
    @IBAction func lastYearAction(_ sender: UIButton) {
        crossToPaymentCategory(days: 365, str: "LAST YEAR")
    }
    
    
    @IBAction func fromButtonAction(_ sender: UIButton) {
        fromButtonBool = true
        addDelBorderToButton(add: fromButton, delete: toButton)
    }
    
    @IBAction func toButtonAction(_ sender: UIButton) {
        fromButtonBool = false
        addDelBorderToButton(add: toButton, delete: fromButton)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.startDate = startDateFilter
        testVC?.endDate = endDateFilter
        testVC?.dataStr = dataStrFilter
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func showButton(_ sender: UIButton) {
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        testVC?.startDate = startDateFilter
        testVC?.endDate = endDateFilter
        testVC?.dataStr = (dateString(date: startDateFilter) + " - " + dateString1(date: endDateFilter), "CUSTOM DATE")
        self.present(testVC!, animated: false, completion: nil)
    }
}
