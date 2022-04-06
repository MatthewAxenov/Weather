//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Матвей on 06.04.2022.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var models = [Current]()
    
    @IBOutlet var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.idendifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static let identifier = "HourlyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
    func configure(with models: [Current]) {
        self.models = models
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 100)
    }
    
    //MARK: Table
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.idendifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
}
