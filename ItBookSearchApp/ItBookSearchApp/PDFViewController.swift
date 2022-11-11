//
//  PDFViewController.swift
//  ItBookSearchApp
//
//  Created by 이재웅 on 2022/11/12.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    private lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        
        return pdfView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
