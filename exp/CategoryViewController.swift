import UIKit
import CoreData

class CategoryViewController: UIViewController {
    @IBOutlet weak var mySearch: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var labelCount: UILabel!
    
    let identifier = "myCell"
    var i = 0
    var count = ""
    var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let section = "name"
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.backgroundColor = UIColor.clear
        mySearch.tintColor = UIColor.white
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        addLabel()
        findBar()
        labelCount.text = count
    }
    
    private func setUpSearchBar() {
        mySearch.delegate = self
    }
    
    static func storyboardInstance() -> CategoryViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
    }
    
    func addLabel() {
        let label = UILabel(frame: CGRect(x: 136, y: 62, width: 101, height: 12))
        label.font = UIFont(name: "GothamPro-Medium", size: 10)
        label.textColor = UIColor(white: 1, alpha: 0.45)
        label.text = "SELECT CATEGORY"
        label.tag = 101
        label.textAlignment = .left
        view.addSubview(label)
        
/*        let label1 = UILabel(frame: CGRect(x: 162.5, y: 45, width: 50, height: 12))
        label1.font = UIFont(name: "GothamPro-Bold", size: 14)
        label1.textColor = UIColor.white
        label1.text = count
        label1.tag = 101
        label1.textAlignment = .center
        view.addSubview(label1)*/
    }
    
    func findBar() {
        //searchBar
        //картинка
        let img = UIImage(named: "searchbar")
        mySearch.setSearchFieldBackgroundImage(img, for: .normal)
        //placeholder
        mySearch.placeholder = "  Search"
        let placeHolderOffSet = UIOffset(horizontal: 125, vertical: 0)
        mySearch.setPositionAdjustment(placeHolderOffSet, for: .search)
        
        let textFieldInsideUISearchBar = mySearch.value(forKey: "searchField") as? UITextField
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
    
    @IBAction func backButton(_ sender: UIButton) {
        let testVC = ViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        self.present(testVC!, animated: false, completion: {
//            testVC?.offCurrencyButton()
            testVC?.showSecondPlan(bool: true)
            testVC?.priceLabel.text = self.labelCount.text
        })
    }
}



extension CategoryViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath) as! Category
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "myCell")
        if (cell == nil)
        {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "myCell")
        }
        
        if indexPath.section == 0 {
            cell?.textLabel?.text = "New category / note"
            cell?.imageView?.image = UIImage(named: "Group")
        } else {
            cell?.textLabel?.text = customer.name
            cell?.imageView?.image = UIImage(named: customer.image?.name ?? "")
        }
        
        cell?.detailTextLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.font = UIFont(name: "GothamPro-Medium", size: 18)
        cell?.textLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.text = ""
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let s: Int = self.fetchedResultsController.fetchedObjects?.count ?? 0
        return s
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCellText = tableView.cellForRow(at: indexPath)
        switch indexPath.section {
        case 0:
            let testVC = NewCatViewController.storyboardInstance()
            testVC?.modalPresentationStyle = .fullScreen
            self.present(testVC!, animated: false, completion: {
                testVC?.count = self.count
            })
        case 1..<100:
            let testVC = ViewController.storyboardInstance()
            self.present(testVC!, animated: false, completion: {
//                testVC?.offCurrencyButton()
                testVC?.showSecondPlan(bool: true)
                testVC?.priceLabel.text = self.count
                testVC?.addTextToCategoryButton(text: currentCellText?.textLabel?.text ?? "")
            })
        default:
            return
        }
        
        currentCellText?.contentView.backgroundColor = UIColor.white
        currentCellText?.textLabel?.textColor = UIColor(red: 0.12, green: 0.53, blue: 0.44, alpha: 1)
    }
    
/*    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    }*/
}

