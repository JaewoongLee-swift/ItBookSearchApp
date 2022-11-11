//
//  PDFViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    var url: String?
    
    private lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        
        return pdfView
    }()
    
    init(url: String) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
