import UIKit
import CoreData

class Payment1CategoryTableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var dateBut: UIButton!
    let identifier = "fd"
    var i = 0
    var startDate = NSDate()
    var endDate = NSDate()
    var dataStr = (String(), String())
    var currency = Currency()
    
    var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let section = "name"
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        return fetchedResultsController
    }()
    
    func findBar() {
        //searchBar
        //картинка
        let img = UIImage(named: "searchbar")
        searchBar.setSearchFieldBackgroundImage(img, for: .normal)
        //placeholder
        searchBar.placeholder = "  Search"
        let placeHolderOffSet = UIOffset(horizontal: 125, vertical: 0)
        searchBar.setPositionAdjustment(placeHolderOffSet, for: .search)
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        //textFieldInsideUISearchBar?.textColor = UIColor.white
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.font = UIFont(name: "GothamPro-Medium", size: 14)
        textFieldInsideUISearchBarLabel?.textColor = UIColor.white
        textFieldInsideUISearchBarLabel?.alpha = 0.31
        
        let glassIconView = textFieldInsideUISearchBar?.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = .white
        glassIconView.alpha = 0.31
    }
    
    func summOfCategory(category: Category, startDate: NSDate, endDate: NSDate, cur: Currency) -> Double {
        var summ = 0.0
        let fromPredicate = NSPredicate(format: "date >= %@", startDate)
        let toPredicate = NSPredicate(format: "date < %@", endDate)
        let predicate = NSPredicate(format: "currency == %@", cur)
        let categoryPredicate = NSPredicate(format: "category.name == %@", category.name!)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, categoryPredicate, predicate])
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
        request.predicate = datePredicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            for object in objects as! [Payment] {
                summ += object.count
            }
        }
        return (Double(round(1000*summ)/1000))
    }
    
    func dateButton() {
        func df(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
        {
            let result = NSMutableAttributedString()
            result.append(left)
            result.append(right)
            return result
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let hw = df(left: NSAttributedString(string: dataStr.0, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "GothamPro-Bold", size: 14) as Any, .paragraphStyle: paragraph ]), right: NSAttributedString(string: " \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 6), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        let helloworld = df(left: hw,  right: NSAttributedString(string: dataStr.1, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.45), NSAttributedString.Key.font: UIFont(name: "GothamPro-Medium", size: 10) as Any, .paragraphStyle: paragraph ]))
        
        
        dateBut.setAttributedTitle(helloworld, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.backgroundColor = UIColor.clear
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        findBar()
        dateButton()
    }
    
    static func storyboardInstance() -> Payment1CategoryTableViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Payment1") as? Payment1CategoryTableViewController
    }
    
    @IBAction func dateFilter(_ sender: UIButton) {
        let testVC = FilterViewController.storyboardInstance()
        testVC!.startDateFilter = startDate
        testVC!.endDateFilter = endDate
        testVC!.dataStrFilter = dataStr
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let textVC = ViewController.storyboardInstance()
        self.present(textVC!, animated: false, completion: nil)
        CoreDataManager.instance.managedObjectContext.reset()
    }
}



extension Payment1CategoryTableViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let s: Int = self.fetchedResultsController.fetchedObjects?.count ?? 0
        return s
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath) as! Category
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "fd")
        if (cell == nil)
        {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "fd")
        }
        cell?.textLabel?.text = customer.name
        cell?.imageView?.image = UIImage(named: customer.image?.name ?? "")
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        

        cell?.detailTextLabel?.text = "$ " + String(summOfCategory(category: customer, startDate: startDate, endDate: endDate, cur: currency))
        cell?.detailTextLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.font = UIFont(name: "GothamPro-Medium", size: 18)
        cell?.textLabel?.textColor = UIColor.white
        return cell!
    }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 18))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18.0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 4
        cell.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds.insetBy(dx: 0, dy: 0)
        var addLine = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.minY), tangent2End: .init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.minY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(white: 1, alpha: 0.1).cgColor
        
        if (addLine == true) {
            let lineLayer = CALayer()
            let lineHeight = 1.0 / UIScreen.main.scale
            lineLayer.frame = CGRect(x: bounds.minX + 10, y: bounds.size.height - lineHeight, width: bounds.size.width - 10, height: lineHeight)
            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }
        
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        cell.backgroundView = testView
    }
/*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "second", sender: self)
        case 1..<array.count:
            //performSegue(withIdentifier: "first", sender: self)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let firstViewController = storyboard.instantiateViewController(withIdentifier: "YourVC") as! ViewController
            self.present(firstViewController, animated: false, completion: {
                firstViewController.showSecondPlan(bool: true)
                firstViewController.addTextToCategoryButton(text: self.array[indexPath.section].name)
            })
        default:
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        i = 0
        guard !searchText.isEmpty else {
            currentarray = array
            myTableView.reloadData()
            return
        }
        currentarray = array.filter({ (elem) -> Bool in
            elem.name.lowercased().contains(searchText.lowercased())
        })
        myTableView.reloadData()
    }
 */
}

