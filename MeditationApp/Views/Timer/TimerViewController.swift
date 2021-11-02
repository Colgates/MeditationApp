//
//  TimerViewController.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 07.09.2021.
//

import Combine
import Lottie
import UIKit
import AVFoundation

enum TimerType {
    case pickerView
    case animationView
}

class TimerViewController: UIViewController {
    
    private var player: AVPlayer?
    private var timer = Timer()
    private var timerType: TimerType = .pickerView
    private var isTimerStarted = false
    
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    
    private var time = 0
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.alpha = 1
        return pickerView
    }()
    
    private let animationView: TimerAnimationView = {
        let animationView = TimerAnimationView()
        animationView.alpha = 0
        return animationView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36)
        label.textColor = Colors.tintColor
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let startButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        button.type = .toggleButton
        return button
    }()
    
    private let stopButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        button.type = .pushButton
        return button
    }()
    
    private let soundsButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(soundsButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        button.type = .pushButton
        return button
    }()
    
    private let changeAppearanceButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(changeAppearanceButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        button.type = .toggleButton
        return button
    }()
    
    private let goBackButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        return button
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let components = [24, 60, 60]
    
    private var selectedSounds: [Sound] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.main
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        setupSoftButton(button: startButton, buttonImage: Images.playButton, selectedButtonImage: Images.pauseButton)
        setupSoftButton(button: stopButton, buttonImage: Images.stopButton, selectedButtonImage: Images.stopButton)
        setupSoftButton(button: soundsButton, buttonImage: Images.soundsButton, selectedButtonImage: Images.soundsButton)
        setupSoftButton(button: changeAppearanceButton, buttonImage: Images.minusButton, selectedButtonImage: Images.circleButton)
        setupSoftButton(button: goBackButton, buttonImage: Images.goBackButton, selectedButtonImage: Images.goBackButton)
        
        getSounds()
    }
    
    private func getSounds() {
        APICaller.shared.getSoundsData()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] sounds in
                self?.selectedSounds = sounds
                self?.configureSoundsMenuButton(with: sounds)
            }
            .store(in: &self.cancellables)
    }
    
    private func configureSoundsMenuButton(with sounds: [Sound]) {
        var actions: [UIAction] = []
        sounds.forEach { item in
            actions.append(UIAction(title: item.title, handler: { action in
                if let randomSound = item.items.randomElement() {
                self.configurePlayer(with: randomSound.url)
                }
            }))}
        self.soundsButton.menu = UIMenu(title: "", children: actions)
        self.soundsButton.showsMenuAsPrimaryAction = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(animationView)
        view.addSubview(pickerView)
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(soundsButton)
        view.addSubview(changeAppearanceButton)
        view.addSubview(goBackButton)
        
        pickerView.frame = CGRect(x: 20, y: 0, width: view.width - 40, height: view.width - 40)
        pickerView.center = view.center
        animationView.frame = CGRect(x: 20, y: 0, width: view.width - 40, height: view.width - 40)
        animationView.center = view.center
        timerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        timerLabel.center = view.center
        
        startButton.frame = CGRect(x: view.width / 2 - 25, y: view.height - 150, width: 50, height: 50)
        stopButton.frame = CGRect(x: view.width / 2 + 75, y: view.height - 150, width: 50, height: 50)
        soundsButton.frame = CGRect(x: view.width / 2 - 125, y: view.height - 150, width: 50, height: 50)
        
        goBackButton.frame = CGRect(x: 30, y: 60, width: 50, height: 50)
        changeAppearanceButton.frame = CGRect(x: view.width - 80, y: 60, width: 50, height: 50)
    }
    
    private func startResumeAnimation() {
        if !animationView.isAnimationStarted {
            animationView.startAnimation(with: Double(time))
        } else {
            animationView.resumeAnimation()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if time < 1 {
            reset()
        } else {
            time -= 1
            switch timerType {
            case .animationView:
                timerLabel.text = formatTime()
            case .pickerView:
                let (h,m,s) = secondsToHoursMinutesSeconds(seconds: time)
                pickerView.selectRow(h, inComponent: 0, animated: true)
                pickerView.selectRow(m, inComponent: 1, animated: true)
                pickerView.selectRow(s, inComponent: 2, animated: true)
            }
        }
    }
    
    private func reset() {
        
        switch timerType {
        case .animationView:
            timerLabel.alpha = 0
            animationView.alpha = 0
            animationView.resetAnimation()
            resetPickerView()
            pickerView.alpha = 1
        case .pickerView:
            resetPickerView()
        }

        soundsButton.isEnabled = true
        hours = 0
        minutes = 0
        seconds = 0
        time = 0
        
        startButton.isSelected = false
        isTimerStarted = false
        timer.invalidate()
    }
    
    private func resetPickerView() {
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
        pickerView.selectRow(0, inComponent: 2, animated: true)
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, seconds % 60)
    }
    
    private func formatTime() -> String {
        let hours = time / 3600
        let minutes = time % 3600 / 60
        let seconds = time % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    private func configurePlayer(with urlString: String) {

        guard let url = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }
    
    private func setupSoftButton(button: SoftUIView, buttonImage: UIImage, selectedButtonImage: UIImage) {
        let image = UIImageView(image: buttonImage)
        image.tintColor = Colors.tintColor
        
        let selectedImage = UIImageView(image: selectedButtonImage)
        selectedImage.tintColor = Colors.selectedTintColor
        
        image.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentView(image, selectedContentView: selectedImage)
        image.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        selectedImage.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        selectedImage.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
}

// MARK: - Buttons Actions

extension TimerViewController {
    
    @objc private func startButtonTapped() {
        guard time != 0 else {
            startButton.isSelected = false
            return }
        soundsButton.isEnabled = false
        
        player?.play()
        
        switch timerType {
        case .animationView:
            if !isTimerStarted {
                pickerView.alpha = 0
                animationView.alpha = 1
                timerLabel.alpha = 1
                startTimer()
                startResumeAnimation()
                isTimerStarted = true
            } else {
                animationView.pauseAnimation()
                timer.invalidate()
                isTimerStarted = false
            }
        case .pickerView:
            if !isTimerStarted {
                startTimer()
                //                pickerView.isUserInteractionEnabled = false
                isTimerStarted = true
            } else {
                timer.invalidate()
                isTimerStarted = false
            }
        }
    }
    
    @objc private func stopButtonTapped() {
        player = nil
        reset()
    }
    
    @objc private func soundsButtonTapped() {
        print("soundsButtonTapped")
    }
    
    @objc private func changeAppearanceButtonTapped() {
        switch timerType {
        case .animationView:
            timerType = .pickerView
            print("picker")
        case .pickerView:
            timerType = .animationView
            print("animation")
        }
    }
    
    @objc private func goBackButtonTapped() {
        reset()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDataSource

extension TimerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components[component]
    }
}

// MARK: - UIPickerViewDelegate

extension TimerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(format: "%02i", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hours = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            print("No component with number \(component)")
        }
        time = hours * 3600 + minutes * 60 + seconds
        timerLabel.text = formatTime()
        print(time)
    }
}
