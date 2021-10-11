//
//  MediaPlayerViewController.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 31.08.2021.
//
import AVFoundation
import UIKit

class MediaPlayerViewController: UIViewController {
    
    private var player:AVPlayer?
    private var playerItem:AVPlayerItem?
    private var playerQueue: AVQueuePlayer?
    
    private var timer: Timer?
    
    private let controlButtonsView = ControlButtonsView()
    
    private let goBackButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        return button
    }()
    
//    private let profileButton: SoftUIView = {
//        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
//        button.cornerRadius = 25
//        return button
//    }()
    
    private let imageView: RoundedShadow = {
        let imageView = RoundedShadow()
        imageView.darkShadowColor = Colors.darkShadow
        imageView.lightShadowColor = Colors.lightShadow
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Apple Color Emoji", size: 20)
        label.textColor = Colors.tintColor
        label.textAlignment = .center
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Apple Color Emoji", size: 16)
        label.textColor = Colors.tintColor
        label.textAlignment = .center
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = 0
        slider.thumbTintColor = Colors.tintColor
        return slider
    }()
    
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.tintColor
        label.textAlignment = .left
        label.text = "00:00"
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.tintColor
        label.textAlignment = .right
        label.text = "00:00"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.main
        controlButtonsView.delegate = self
        
        addSubviews()
        
        setupGoBackButton()
//        setupProfileButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        goBackButton.frame = CGRect(x: 30, y: 60, width: 50, height: 50)
//        profileButton.frame = CGRect(x: view.width - 80, y: 60, width: 50, height: 50)
        
        imageView.frame = CGRect(x: view.center.x - 125, y: view.center.y - 250, width: 250, height: 250)
        
        titleLabel.frame = CGRect(x: 20, y: view.center.y + 20, width: view.width - 40, height: 50)
        authorLabel.frame = CGRect(x: 20, y: titleLabel.bottom, width: view.width - 40, height: 30)
        
        slider.frame = CGRect(x: 30, y: authorLabel.bottom + 40, width: view.width - 60, height: 30)
        elapsedTimeLabel.frame = CGRect(x: 30, y: slider.top - 20, width: 40, height: 20)
        remainingTimeLabel.frame = CGRect(x: slider.right - 50, y: slider.top - 20, width: 50, height: 20)
        
        controlButtonsView.frame = CGRect(x: 20, y: view.height - 200, width: view.width - 40, height: 100)
    }
    
    private func addSubviews() {
        view.addSubview(goBackButton)
//        view.addSubview(profileButton)
        view.addSubview(controlButtonsView)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(slider)
        view.addSubview(elapsedTimeLabel)
        view.addSubview(remainingTimeLabel)
        view.addSubview(authorLabel)
    }
    
    private func setupGoBackButton() {
        
        let menuImage = UIImageView(image: Images.goBackButton)
        menuImage.tintColor = Colors.tintColor
        
        let menuImageSelected = UIImageView(image: Images.goBackButton)
        menuImageSelected.tintColor = Colors.selectedTintColor
        
        menuImage.translatesAutoresizingMaskIntoConstraints = false
        menuImageSelected.translatesAutoresizingMaskIntoConstraints = false
        
        goBackButton.setContentView(menuImage, selectedContentView: menuImageSelected)
        menuImage.centerXAnchor.constraint(equalTo: goBackButton.centerXAnchor).isActive = true
        menuImage.centerYAnchor.constraint(equalTo: goBackButton.centerYAnchor).isActive = true
        menuImageSelected.centerXAnchor.constraint(equalTo: goBackButton.centerXAnchor).isActive = true
        menuImageSelected.centerYAnchor.constraint(equalTo: goBackButton.centerYAnchor).isActive = true
    }
    
//    private func setupProfileButton() {
//
//        let profileImage = UIImageView(image: Images.profileButton)
//        profileImage.tintColor = Colors.tintColor
//
//        let profileImageSelected = UIImageView(image: Images.profileButton)
//        profileImageSelected.tintColor = Colors.selectedTintColor
//
//        profileImage.translatesAutoresizingMaskIntoConstraints = false
//        profileImageSelected.translatesAutoresizingMaskIntoConstraints = false
//
//        profileButton.setContentView(profileImage, selectedContentView: profileImageSelected)
//        profileImage.centerXAnchor.constraint(equalTo: profileButton.centerXAnchor).isActive = true
//        profileImage.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor).isActive = true
//        profileImageSelected.centerXAnchor.constraint(equalTo: profileButton.centerXAnchor).isActive = true
//        profileImageSelected.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor).isActive = true
//    }
    
    private func configurePlayer(with urlString: String) {

        guard let url = URL(string: urlString) else { return }

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player)
        self.view.layer.addSublayer(playerLayer)

        let asset = AVAsset(url: url)
        let keys: [String] = ["playable"]

        asset.loadValuesAsynchronously(forKeys: keys) {

        let status = asset.statusOfValue(forKey: "playable", error: nil)

        switch status {
            case .loaded:
                DispatchQueue.main.async {

                    let duration: CMTime = playerItem.asset.duration
                    let seconds: Float64 = CMTimeGetSeconds(duration)

                    self.slider.maximumValue = Float(seconds)
                    self.slider.isContinuous = true
                }
                break
            case .failed:
                DispatchQueue.main.async {
                    print("failed")
                }
                break
            case .cancelled:
                DispatchQueue.main.async {
                    print("cancelled")
                }
                break
            default:
                break
            }
        }
    }
    
    @objc private func goBackButtonTapped() {
        player?.pause()
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func profileButtonTapped() {
        print("profile")
    }
    
    @objc private func sliderValueChanged(_ playbackSlider: UISlider) {
        let seconds: Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        let currentTimeSeconds: Float64 = CMTimeGetSeconds(targetTime)
        elapsedTimeLabel.text = getFormattedTime(timeInterval: currentTimeSeconds)
        player?.seek(to: targetTime)
    }
    
    @objc private func updateProgress() {
        if let player = player {
            let currentTimeSeconds: Float64 = CMTimeGetSeconds(player.currentTime())
            elapsedTimeLabel.text = getFormattedTime(timeInterval: currentTimeSeconds)
            slider.value = Float(currentTimeSeconds)
        }
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secStr = timeFormatter.string(from: NSNumber(value: secs)) else { return "00:00" }
        return "\(minsString):\(secStr)"
    }
    
    func configure(with item: Item) {
        titleLabel.text = item.title
        authorLabel.text = item.author ?? ""
        remainingTimeLabel.text = item.length
        let image = UIImageView()
        image.sd_setImage(with: URL(string: item.imageURL), completed: nil)
        imageView.image = image.image
        configurePlayer(with: item.url)
    }
}

// MARK: - ControlButtonsViewDelegate

extension MediaPlayerViewController: ControlButtonsViewDelegate {
    func shuffleButtonTapped() {
        print("shuffle")
    }
    
    func backButtonTapped() {
        print("back")
    }
    
    func playButtonTapped() {
        
        if player?.rate == 0
        {
            player?.play()
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            }
        } else {
            player?.pause()
        }
    }
    
    func forwardButtonTapped() {
        print("forward")
    }
    
    func repeatButtonTapped() {
        print("repeat")
    }
}
