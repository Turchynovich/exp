import UIKit
import CoreData

class MyPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    weak var myDelegate: MyPageViewControllerDelegate?
    fileprivate lazy var pages: [UIViewController] = {
        return [self.getViewController(withIdentifier: "TodayViewController"),
                self.getViewController(withIdentifier: "YesterdayViewController"),
                self.getViewController(withIdentifier: "LastWeekViewController"),
                self.getViewController(withIdentifier: "LastMonthViewController")]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isAppAlreadyLaunchedOnce() {
            createNewCoreData()
            currencyDegault()
        }
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        myDelegate?.myPageViewController(myPageViewController: self, didUpdatePageCount: pages.count)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard pages.count > previousIndex else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        guard pages.count > nextIndex else {
            return nil
        }
        return pages[nextIndex]
    }

    //запись в базу картинок
    func saveimage(imageName: String) {
        let managedObject = Image()
        managedObject.name = imageName
        CoreDataManager.instance.saveContext()
    }

    
    //запись в базу валют
    
    func saveCurrency(name: String, symbol: String, code: String, status: Bool) {
        let managedObject = Currency()
        managedObject.name = name
        managedObject.code = code
        managedObject.symbol = symbol
        managedObject.status = status
        CoreDataManager.instance.saveContext()
    }
    
    //запись в базу категории
    func savecategory(categoryName: String, imageName: String) {
        let managedObject = Category()
        managedObject.name = categoryName
        
        var image: Image!
        let predicate = NSPredicate(format: "name == %@", imageName)
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Image")
        request.predicate = predicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            if objects.count >= 1 {
                image = objects[0] as? Image
            }
        }
        managedObject.image = image
        CoreDataManager.instance.saveContext()
    }
    
    //определяет первый запуск приложения или нет
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            //print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    //очистка базы и создание категорий по умолчанию
    func createNewCoreData() {
        /*
        func delete(table: String) {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: table)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try CoreDataManager.instance.managedObjectContext.execute(batchDeleteRequest)
            } catch {
            }
        }*/
        let firstStart = FirstStart()
        /*for i in firstStart.tables {
            delete(table: i)
        }*/
        
        for i in firstStart.imagesArray {
            saveimage(imageName: i)
        }
        
        for i in firstStart.categorysArray {
            savecategory(categoryName: i.0, imageName: i.1)
        }
        
        for value in firstStart.currencyArray {
            saveCurrency(name: value.0, symbol: value.1, code: value.2, status: false)
        }
    }
    
    //При первом запуске определяет валюту из региога телефона и устанавливает ее по умолчанию
    func currencyDegault() {
        let localeCyrrencyCode = Locale.current.currencyCode
        if let str = localeCyrrencyCode {
            let predicate = NSPredicate(format: "code == %@", str)
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
            fetchRequest.predicate = predicate
            do {
                let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
                for result in results as! [Currency] {
                    result.status = true
                }
            }
            CoreDataManager.instance.saveContext()
        }
    }

}


extension MyPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first, let index = pages.index(of: firstViewController) {
            myDelegate?.myPageViewController(myPageViewController: self, didUpdatePageIndex: index)
        }
    }
}

protocol MyPageViewControllerDelegate: class {
    func myPageViewController(myPageViewController: MyPageViewController, didUpdatePageCount count: Int)
    func myPageViewController(myPageViewController: MyPageViewController, didUpdatePageIndex index: Int)
}
