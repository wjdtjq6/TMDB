//
//  TempViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/25/24.
//
import UIKit
//temp
class TempViewController: UIViewController {
    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        imageView.image = UIImage(named: "IMG_2373")
        imageView.contentMode = .scaleAspectFill
    }

}

