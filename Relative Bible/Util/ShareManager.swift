//
//  ShareManager.swift
//  Bible
//
//  Created by Jun Ke on 8/16/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import Foundation
import Photos

class ShareManager {
    
//    enum ShareMedia: Int {
//        case Facebook = 1000
//        case Instagram
//        case Messenger
//        case WhatsApp
//        case Twitter
//        case WeChat
//        case QQ
//        case SinaWeibo
//        case saveToPhotos
//    }
//
//    static func share(media: ShareMedia, verse: Verse?, words: String?, presentingViewController: UIViewController, imageSaveTarget: AlertControllerPresentable?) {
//        switch media {
//        case .Facebook:
//            let shareDialog = FBSDKShareDialog.init()
//            let photo = FBSDKSharePhoto.init(image: createPostcardImage(verse: verse, words: words), userGenerated: true)
//            let content = FBSDKSharePhotoContent.init()
//            content.photos = [photo as Any]
//            shareDialog.shareContent = content
//            shareDialog.mode = .native
//            shareDialog.fromViewController = presentingViewController
//            print(shareDialog.show())
//        case .WeChat:
//            let image = createPostcardImage(verse: verse, words: words)
//            let message = WXMediaMessage.init()
//            let imageObject = WXImageObject.init()
//            imageObject.imageData = image.pngData()!
//            message.mediaObject = imageObject
//            let request = SendMessageToWXReq.init()
//            request.bText = false
//            request.message = message
//            request.scene = Int32(WXSceneSession.rawValue)
//            WXApi.send(request)
//        case .Instagram:
//            let image = createPostcardImage(verse: verse, words: words)
//            do {
//                try PHPhotoLibrary.shared().performChangesAndWait {
//                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
//                    let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
//                    let shareURL = "instagram://library?LocalIdentifier=" + assetID
//                    let instagramURL = URL.init(string: "instagram://app")!
//                    if UIApplication.shared.canOpenURL(instagramURL) {
//                        if let urlForRedirect = URL.init(string: shareURL) {
//                            UIApplication.shared.open(urlForRedirect, options: [:], completionHandler: nil)
//                        }
//                    }
//                }
//            } catch {
//                print("failed to open Instagram")
//            }
//        case .Messenger:
//            let messageDialog = FBSDKMessageDialog.init()
//            let photo = FBSDKSharePhoto.init(image: createPostcardImage(verse: verse, words: words), userGenerated: true)
//            let content = FBSDKSharePhotoContent.init()
//            content.photos = [photo as Any]
//            messageDialog.shareContent = content
//            messageDialog.show()
//        case .WhatsApp:
//            let url = URL.init(string: "whatsapp://send?text=Hello%2C%20World!")!
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        case .saveToPhotos:
//            let image = createPostcardImage(verse: verse, words: words)
//            if let target = imageSaveTarget {
//                UIImageWriteToSavedPhotosAlbum(image, presentingViewController, #selector(target.image(_:didFinishSavingWithError:contextInfo:)), nil)
//            } else {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//        default:
//            print("default")
//        }
//    }
//
//    static func createPostcardImage(verse: Verse?, words: String?) -> UIImage {
//        let background = UIView.init(frame: .init(x: 0, y: 0, width: 425, height: CGFloat.greatestFiniteMagnitude))
//        background.backgroundColor = UIColor.white
//        let v = UIView.init(frame: .init(x: 0, y: 0, width: 375, height: CGFloat.greatestFiniteMagnitude))
//        v.backgroundColor = UIColor.clear
//        let headerImageView = UIImageView.init()
//        headerImageView.image = UIImage.init(named: "postcard header")
//        headerImageView.contentMode = .scaleAspectFit
//        v.addSubview(headerImageView)
//        headerImageView.translatesAutoresizingMaskIntoConstraints = false
//        headerImageView.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
//        headerImageView.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
//        headerImageView.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
//        headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor, multiplier: 104 / 375).isActive = true
//        let bibleSaysLabel = UILabel.init()
//        bibleSaysLabel.text = "The Bible Says..."
//        bibleSaysLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
//        v.addSubview(bibleSaysLabel)
//        bibleSaysLabel.translatesAutoresizingMaskIntoConstraints = false
//        bibleSaysLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 12).isActive = true
//        bibleSaysLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 38).isActive = true
//        let verseLabel = UILabel.init()
//        if let verse = verse {
//            verseLabel.text = verse.content
//        }
//        verseLabel.numberOfLines = 0
//        verseLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
//        v.addSubview(verseLabel)
//        verseLabel.translatesAutoresizingMaskIntoConstraints = false
//        verseLabel.topAnchor.constraint(equalTo: bibleSaysLabel.bottomAnchor, constant: 10).isActive = true
//        verseLabel.leadingAnchor.constraint(equalTo: bibleSaysLabel.leadingAnchor).isActive = true
//        verseLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -38).isActive = true
//        let sourceLabel = UILabel.init()
//        sourceLabel.text = verse?.description
//        sourceLabel.textColor = UIColor.palette[3]
//        sourceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        v.addSubview(sourceLabel)
//        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
//        sourceLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
//        sourceLabel.topAnchor.constraint(equalTo: verseLabel.bottomAnchor, constant: 6).isActive = true
//        let versionLabel = UILabel.init()
//        versionLabel.text = "King James Version"
//        versionLabel.textColor = UIColor.palette[3]
//        versionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        v.addSubview(versionLabel)
//        versionLabel.translatesAutoresizingMaskIntoConstraints = false
//        versionLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
//        versionLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 6).isActive = true
//        let line1 = UIView.init()
//        line1.backgroundColor = UIColor.palette[3]
//        v.addSubview(line1)
//        line1.translatesAutoresizingMaskIntoConstraints = false
//        line1.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 20).isActive = true
//        line1.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -20).isActive = true
//        line1.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 15).isActive = true
//        line1.heightAnchor.constraint(equalToConstant: 2).isActive = true
//        let line2 = UIView.init()
//        line2.backgroundColor = UIColor.palette[2]
//        v.addSubview(line2)
//        line2.translatesAutoresizingMaskIntoConstraints = false
//        line2.leadingAnchor.constraint(equalTo: line1.leadingAnchor).isActive = true
//        line2.trailingAnchor.constraint(equalTo: line1.trailingAnchor).isActive = true
//        line2.heightAnchor.constraint(equalToConstant: 2).isActive = true
//        line2.topAnchor.constraint(equalTo: line1.bottomAnchor, constant: 4).isActive = true
//        let fromMeLabel = UILabel.init()
//        fromMeLabel.text = "FROM ME"
//        fromMeLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
//        v.addSubview(fromMeLabel)
//        fromMeLabel.translatesAutoresizingMaskIntoConstraints = false
//        fromMeLabel.topAnchor.constraint(equalTo: line2.bottomAnchor, constant: 10).isActive = true
//        fromMeLabel.leadingAnchor.constraint(equalTo: verseLabel.leadingAnchor).isActive = true
//        let wordsLabel = UILabel.init()
//        wordsLabel.text = words
//        wordsLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        wordsLabel.numberOfLines = 0
//        v.addSubview(wordsLabel)
//        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
//        wordsLabel.leadingAnchor.constraint(equalTo: fromMeLabel.leadingAnchor).isActive = true
//        wordsLabel.trailingAnchor.constraint(equalTo: verseLabel.trailingAnchor).isActive = true
//        wordsLabel.topAnchor.constraint(equalTo: fromMeLabel.bottomAnchor, constant: 12).isActive = true
//        let vinesImageView = UIImageView.init()
//        vinesImageView.image = UIImage.init(named: "symmetric vines")
//        vinesImageView.contentMode = .scaleAspectFit
//        v.addSubview(vinesImageView)
//        vinesImageView.translatesAutoresizingMaskIntoConstraints = false
//        vinesImageView.topAnchor.constraint(equalTo: wordsLabel.bottomAnchor, constant: 23).isActive = true
//        vinesImageView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 45).isActive = true
//        vinesImageView.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -45).isActive = true
//        vinesImageView.heightAnchor.constraint(equalTo: vinesImageView.widthAnchor, multiplier: 89 / 280).isActive = true
//        v.layoutIfNeeded()
//        v.frame = CGRect.init(x: 0, y: 0, width: v.bounds.width, height: vinesImageView.frame.maxY + 22)
//        _ = v.setGradientBackground(top: UIColor.white, bottom: UIColor.init(hex: "F9F9F9"), cornerRadius: 26)
//        v.layer.cornerRadius = 26
//        v.layer.shadowColor = UIColor.black.cgColor
//        v.layer.shadowOffset = .zero
//        v.layer.shadowOpacity = 0.5
//        v.layer.shadowRadius = 5
//        background.addSubview(v)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.topAnchor.constraint(equalTo: background.topAnchor, constant: 25).isActive = true
//        v.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 25).isActive = true
//        v.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -25).isActive = true
//        v.heightAnchor.constraint(equalToConstant: v.bounds.height).isActive = true
//        background.layoutIfNeeded()
//        background.frame = CGRect.init(x: 0, y: 0, width: background.bounds.width, height: v.frame.maxY + 25)
//        return background.renderedImage
//    }
//
}
//
//@objc protocol AlertControllerPresentable {
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
//}



