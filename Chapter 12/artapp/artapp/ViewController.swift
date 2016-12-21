//
//  ViewController.swift
//  ArtApp
//
//  Created by Donny Wals on 22/08/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var videoView: UIView!
    let captureSession = AVCaptureSession()
    
    @IBOutlet var hConstraint: NSLayoutConstraint!
    @IBOutlet var vConstraint: NSLayoutConstraint!

    @IBOutlet var nearbyArtLabel: UILabel!
    let locationManager: CLLocationManager = CLLocationManager()
    
    var motionManager: CMMotionManager!
    var startRoll: Int?
    var startPitch: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMotionUpdates()
        setupCameraView()
        setupLocationUpdates()
    }
    
    func setupLocationUpdates() {
        locationManager.delegate = self
        
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            startLocationTracking()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startLocationTracking()
        }
    }

    func startLocationTracking() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last
            else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, _ in
            guard let placemark = placemarks?.first,
                let city = placemark.locality
                else { return }

            self?.nearbyArtLabel.text = "Explore 17 pieces of art in \(city)"
        })
        
        manager.stopUpdatingLocation()
    }
    
    func setupMotionUpdates() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { data, _ in
            guard let motionData = data
                else { return }
            
            let roll = Int(motionData.attitude.roll * 180 / .pi)
            let pitch = Int(motionData.attitude.pitch * 180 / .pi)
            
            if self.startRoll == nil { self.startRoll = roll }
            if self.startPitch == nil { self.startPitch = pitch }
            
            guard let startRoll = self.startRoll,
                let startPitch = self.startPitch
                else { return }
            
            self.vConstraint.constant = CGFloat(pitch - startPitch)
            self.hConstraint.constant = -CGFloat(roll - startRoll)
        }
    }
    
    func setupCameraView() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { authorized in
                if authorized {
                    self.displayCamera()
                } else {
                    print("Did not authorize")
                }
            }
        case .authorized:
            displayCamera()
        case .denied, .restricted:
            print("No access granted")
        }
    }
    
    func displayCamera() {
        guard let availableCameras = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice]
            else { return }
        
        var backCamera: AVCaptureDevice?
        
        for camera in availableCameras  {
            if camera.position == .back {
                backCamera = camera
            }
        }
        
        guard let camera = backCamera,
            let input = try? AVCaptureDeviceInput(device: camera)
            else { return }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        guard let preview = AVCaptureVideoPreviewLayer(session: captureSession)
            else { return }
        
        preview.frame = view.bounds
        videoView.layer.addSublayer(preview)
        
        captureSession.startRunning()
    }
}
