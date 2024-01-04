//
//  ViewController.swift
//  Assignment3_CollectionView
//
//  Created by Mac on 04/01/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var post : [Post] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromApi()
        initlizeCollectionView()
        registerXibWithCollectionView()
        
    }
    
    func initlizeCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerXibWithCollectionView(){
        let uiNib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(uiNib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    func fetchDataFromApi(){
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
        var UrlRequest = URLRequest(url: url!)
        UrlRequest.httpMethod = "Get"
        
        var urlSesson = URLSession(configuration: .default)
        
        let dataTask = urlSesson.dataTask(with: UrlRequest) { postData, postResponse, postError in
            let urlResponse = try! JSONSerialization.jsonObject(with: postData!)
            
            for eachResponse in urlResponse as! [[String : Any]] {
                let postDictonary = eachResponse as! [String :Any]
                let userId = postDictonary["userId"] as! Int
                let id = postDictonary["id"] as! Int
                let title = postDictonary["title"] as! String
                let completed = postDictonary["completed"] as! Bool
                
                let postObject = Post(userId: userId, id: id, title: title, completed: completed)
                
                self.post.append(postObject)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        dataTask.resume()
    }

}
extension ViewController : UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
}


extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweetheCell : CGFloat = (flowLayout.minimumInteritemSpacing ?? 0.0) + (flowLayout.sectionInset.left ?? 0.0) + (flowLayout.sectionInset.right ?? 0.0)
        let size = (self.collectionView.frame.width - spaceBetweetheCell) / 2
        return CGSize(width: size, height: size)
    }
}


extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        customCollectionViewCell.userIdLabel.text = String(post[indexPath.row].userId)
        customCollectionViewCell.idLabel.text = String(post[indexPath.row].id)
        customCollectionViewCell.titleLable.text = (post[indexPath.row].title)
        customCollectionViewCell.completedLabel.text = String(post[indexPath.row].completed)
        return customCollectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        post.count
    }
}
