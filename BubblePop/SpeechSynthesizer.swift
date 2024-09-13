//
//  SpeechSynthesizer.swift
//  BubblePop
//
//  Created by Krupanshu Sharma on 13/09/24.
//
import AVFoundation

class SpeechSynthesizer {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
