//
//  MessageTableViewCell.swift
//  Exercise2
//
//  Created by David Munoz on 02/08/2018.
//  Copyright © 2018 David Munoz. All rights reserved.
//

//Here are the rest of that code, but with some modification to adapt to my exercise
//source : https://medium.com/@dima_nikolaev/creating-a-chat-bubble-which-looks-like-a-chat-bubble-in-imessage-the-advanced-way-2d7497d600ba
import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private var bubbleView :BubbleView?
    private var messageLabel: UILabel?
    private var messageImageView: UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func show(message:Message){
        if message.sender == SenderTypes.me.rawValue {
            displayMessage(message: message, isIncoming: false)
        }else{
            displayMessage(message: message, isIncoming: true)
        }
    }
    
    fileprivate func displayMessage(message:Message, isIncoming: Bool) {
        if let bubble = bubbleView {
            bubble.removeFromSuperview()
            bubbleView = nil
        }
        if let message = messageLabel {
            message.removeFromSuperview()
            messageLabel = nil
        }
        if let messageImageView = messageImageView {
            messageImageView.removeFromSuperview()
        }
        if let text = message.text {
            messageLabel =  UILabel()
            messageLabel!.numberOfLines = 0
            messageLabel!.font = UIFont.systemFont(ofSize: 18)
            messageLabel!.textColor = .white
            messageLabel!.text = text
            
            let constraintRect = CGSize(width: 0.66 * contentView.frame.width,
                                        height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [.font: messageLabel!.font],
                                                context: nil)
            messageLabel!.frame.size = CGSize(width: ceil(boundingBox.width),
                                      height: ceil(boundingBox.height))
            
            let bubbleSize = CGSize(width: messageLabel!.frame.width + 28,
                                    height: messageLabel!.frame.height + 20)
            
            bubbleView = BubbleView()
            bubbleView?.isIncoming = isIncoming
            bubbleView?.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            messageLabel?.translatesAutoresizingMaskIntoConstraints = false
            bubbleView!.backgroundColor = .clear
            contentView.addSubview(bubbleView!)
            contentView.addSubview(messageLabel!)

            if isIncoming{
                bubbleView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            }else{
                bubbleView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            }
            bubbleView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            bubbleView?.widthAnchor.constraint(equalToConstant: bubbleSize.width).isActive = true
            bubbleView?.heightAnchor.constraint(equalToConstant: bubbleSize.height).isActive = true
            messageLabel?.leadingAnchor.constraint(equalTo: bubbleView!.leadingAnchor, constant: 14).isActive = true
            messageLabel!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            messageLabel?.trailingAnchor.constraint(equalTo: bubbleView!.trailingAnchor, constant: -5).isActive = true
        }else{
            if let image = message.image {
                let width: CGFloat = 0.66 * contentView.frame.width
                let height: CGFloat =  width / 0.90
                
                bubbleView = BubbleView()
                bubbleView!.isIncoming = isIncoming

                bubbleView!.backgroundColor = .clear
                bubbleView!.frame.size = CGSize(width: width, height: height)
                

                messageImageView = UIImageView(image: image)
                messageImageView!.translatesAutoresizingMaskIntoConstraints = false
                messageImageView!.contentMode = .scaleAspectFill
                messageImageView!.clipsToBounds = true
                messageImageView!.mask = bubbleView!
                contentView.addSubview(messageImageView!)

                if isIncoming{
                    messageImageView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                }else{
                    messageImageView!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                }
                messageImageView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                messageImageView!.widthAnchor.constraint(equalToConstant: width).isActive = true
                messageImageView!.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
    }
    
    
    func getPreferedHeightFor(message:Message)->CGFloat{
        if let text = message.text {
            let label =  UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = .white
            label.text = text
            
            let constraintRect = CGSize(width: 0.66 * contentView.frame.width,
                                        height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [.font: label.font],
                                                context: nil)
            label.frame.size = CGSize(width: ceil(boundingBox.width),
                                              height: ceil(boundingBox.height))
            
            let bubbleSize = CGSize(width: label.frame.width + 28,
                                    height: label.frame.height + 20)
            
            return bubbleSize.height + 10
        }else{
            let width: CGFloat = 0.66 * contentView.frame.width
            let height: CGFloat = width / 0.90
            return height + 20
        }
    }
}
