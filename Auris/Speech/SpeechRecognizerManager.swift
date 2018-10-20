//
//  SpeechAuthManager.swift
//  Auris
//
//  Created by Juan David Cruz Serrano on 10/19/18.
//  Copyright © 2018 Juan David Cruz Serrano. All rights reserved.
//

import Foundation
import AVFoundation
import Speech

class SpeechRecognizerManager: NSObject {
    
    let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer()!
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    // MARK: - Initialization Method
    override init() {
        super.init()
    }
    
    static let shared: SpeechRecognizerManager = {
        let instance = SpeechRecognizerManager()
        return instance
    }()
    
    func askPermission(_ completition: @escaping (_ allowed: Bool) -> ()) {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
                
            case .authorized:
                completition(true)
                break
            case .denied:
                completition(false)
                break
            case .notDetermined:
                completition(false)
                break
            case .restricted:
                completition(false)
                break
            }
        }
    }
    
    func startSpeechRecording(_ pLocale: Locale) throws {

        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        
        try audioEngine.start()
        
        if let currentSpeechRecognizer = SFSpeechRecognizer(locale: pLocale) {
            speechRecognizer = currentSpeechRecognizer
        } else {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        }
        
        
        if !speechRecognizer.isAvailable {
            throw NSError(domain: "Speech Recognizer is Unavailable!", code: 500, userInfo: nil)
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: request, delegate: self)
        
    }
    
    func stopRecording() {
        audioEngine.stop()
        request.endAudio()
    }
    
    func cancelRecording() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
    
}

extension SpeechRecognizerManager: SFSpeechRecognitionTaskDelegate {
    
    func speechRecognitionDidDetectSpeech(_ task: SFSpeechRecognitionTask) {
        print(task)
    }
    
    func speechRecognitionTaskWasCancelled(_ task: SFSpeechRecognitionTask) {
        print(task)
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        print(task)
    }
    
    func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
        print(task)
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        print(task)
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        print(recognitionResult.transcriptions)
    }
    
}
