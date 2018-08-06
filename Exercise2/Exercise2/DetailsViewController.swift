//
//  DetailsViewController.swift
//  Exercise2
//
//  Created by David Munoz on 03/08/2018.
//  Copyright © 2018 David Munoz. All rights reserved.
//

import UIKit
import WebKit
class DetailsViewController: UIViewController {

    @IBOutlet weak var textMessageInfoStackView: UIStackView!
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var message : Message!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = message.text {
            
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: message.text!, options: [], range: NSRange(location: 0, length: message.text!.count))

            if matches.count > 0 {
                let match = matches.first!
                senderLabel.text = match.url?.absoluteString
                dateLabel.text = ""

                webView.isHidden = false
                let url = match.url!
                webView.load(URLRequest(url: url))
            }else{
                senderLabel.text = "Sent by: \(message.sender == SenderTypes.me.rawValue ? "You" : "Echoes")"
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateLabel.text = "On: \(dateFormatterGet.string(from: message.sentDate))"
            }
            textMessageInfoStackView.isHidden = false

        }else{
            
            detailedImageView.isHidden = false
            detailedImageView.image = message.image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if !webView.isHidden{
            webView.stopLoading()
        }
        self.dismiss(animated: true)
    }

}
