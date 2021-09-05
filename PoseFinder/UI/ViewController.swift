/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The implementation of the application's view controller, responsible for coordinating
 the user interface, video feed, and PoseNet model.
*/

import AVFoundation
import UIKit
import VideoToolbox

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    private var animator: UIViewPropertyAnimator?
    var player: AVAudioPlayer?
    @IBOutlet var textLab: UILabel!
    @IBOutlet var countLab: UILabel!
    var count = 0
    var nameWO = ""
    /// The view the controller uses to visualize the detected poses.
    @IBOutlet private var previewImageView: PoseImageView!
    
    
    private let videoCapture = VideoCapture()

    private var poseNet: PoseNet!

    /// The frame the PoseNet model is currently making pose predictions from.
    private var currentFrame: CGImage?

    /// The algorithm the controller uses to extract poses from the current frame.
    private var algorithm: Algorithm = .multiple

    /// The set of parameters passed to the pose builder when detecting poses.
    private var poseBuilderConfiguration = PoseBuilderConfiguration()

    private var popOverPresentationManager: PopOverPresentationManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //print(nameWO)
        textLab.text = nameWO
        previewImageView.name = nameWO
        // For convenience, the idle timer is disabled to prevent the screen from locking.
        UIApplication.shared.isIdleTimerDisabled = true

        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }

        poseNet.delegate = self
        setupAndBeginCapturingVideoFrames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    
    private func setupAndBeginCapturingVideoFrames() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }

            self.videoCapture.delegate = self

            self.videoCapture.startCapturing()
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animator?.stopAnimation(true)
        if let animator = animator, animator.state != .inactive {
            animator.finishAnimation(at: .current)
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
        videoCapture.stopCapturing {
            super.viewWillDisappear(animated)
            
        }
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Reinitilize the camera to update its output stream with the new orientation.
        setupAndBeginCapturingVideoFrames()
    }

    @IBAction func onCameraButtonTapped(_ sender: Any) {
        videoCapture.flipCamera { error in
            if let error = error {
                print("Failed to flip camera with error \(error)")
            }
        }
    }

    @IBAction func onAlgorithmSegmentValueChanged(_ sender: UISegmentedControl) {
        guard let selectedAlgorithm = Algorithm(
            rawValue: sender.selectedSegmentIndex) else {
                return
        }

        algorithm = selectedAlgorithm
    }
}

// MARK: - Navigation

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let uiNavigationController = segue.destination as? UINavigationController else {
            return
        }
        guard let configurationViewController = uiNavigationController.viewControllers.first
            as? ConfigurationViewController else {
                    return
        }

        configurationViewController.configuration = poseBuilderConfiguration
        configurationViewController.algorithm = algorithm
        configurationViewController.delegate = self

        popOverPresentationManager = PopOverPresentationManager(presenting: self,
                                                                presented: uiNavigationController)
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = popOverPresentationManager
    }
}

// MARK: - ConfigurationViewControllerDelegate

extension ViewController: ConfigurationViewControllerDelegate {
    func configurationViewController(_ viewController: ConfigurationViewController,
                                     didUpdateConfiguration configuration: PoseBuilderConfiguration) {
        poseBuilderConfiguration = configuration
    }

    func configurationViewController(_ viewController: ConfigurationViewController,
                                     didUpdateAlgorithm algorithm: Algorithm) {
        self.algorithm = algorithm
    }
}

// MARK: - VideoCaptureDelegate

extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }

        currentFrame = image
        poseNet.predict(image)
    }
}

// MARK: - PoseNetDelegate

extension ViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame)

        let poses = algorithm == .single
            ? [poseBuilder.pose]
            : poseBuilder.poses

        previewImageView.show(poses: poses, on: currentFrame)
        if(nameWO == "Squats")
        {// neu la squat thi 2 chan > 100 do
            if (previewImageView.rk <= 100 && previewImageView.lk <= 100 ) && (previewImageView.rk > 0 && previewImageView.lk > 0 ){
                //count = count + 1
                self.countLab.text = String("🟢")
                playSound()
            }
            else{
                self.countLab.text = String("🔴")
            }
        }
        else if (nameWO == "Standing dumbbell")
        {//neu la standing dumbell thi 2 chan lon hon 100 do va 2 tay be hon 100 do
            if (previewImageView.re <= 95 && previewImageView.le <= 95 ) && (previewImageView.rk > 90 && previewImageView.lk > 90 ){
                //count = count + 1
                self.countLab.text = String("🟢")
                playSound()
            }
            else{
                self.countLab.text = String("🔴")
            }
        }
        else if (nameWO == "Planks")
        {//2 tay be hon 90 do va 2 chan lon hon 145
            if (previewImageView.re <= 90 && previewImageView.le <= 90 ) && (previewImageView.re > 0 && previewImageView.le > 0 ) && (previewImageView.rk > 145 && previewImageView.lk > 145 ){
                //count = count + 1
                self.countLab.text = String("🟢")
                playSound()
            }
            else{
                self.countLab.text = String("🔴")
            }
        }
        else if (nameWO == "Pushups")
        {//2 chan lon hon 145 va 2 tay hon 90
            if (previewImageView.re <= 90 && previewImageView.le <= 90 ) && (previewImageView.le > 0 && previewImageView.re > 0 ) && (previewImageView.rk > 145 && previewImageView.lk > 145 ){
                //count = count + 1
                self.countLab.text = String("🟢")
                playSound()
            }
            else{
                self.countLab.text = String("🔴")
            }
        }
        
    }
    

    func playSound() {
        guard let url = Bundle.main.url(forResource: "ok", withExtension: "mp3") else {
            print("url not found")
            return
        }

        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            /// change fileTypeHint according to the type of your audio file (you can omit this)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: "")

            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

}

