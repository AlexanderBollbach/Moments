//
//  ViewController.m
//  AUTest3
//
//  Created by Alexander Bollbach on 7/23/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
#import "AudioEngine.h"
#import "MyAudioUnit3.h"

@interface ViewController (){
    AudioEngine *_audioEngine;
    AUAudioUnit * au;
    AUAudioUnit * au2;
    AUAudioUnit * au3;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Generator;
    desc.componentSubType = 0x6d617533;
    desc.componentManufacturer = 0x4d415533;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    
    [AUAudioUnit registerSubclass:MyAudioUnit3.self asComponentDescription:desc name:@"Local WaveSynth" version:1];
    
    _audioEngine = [[AudioEngine alloc] init];

    [_audioEngine setupAUWithComponentDescription:desc andCompletion:^(AUAudioUnit *unit) {
        
        au = unit;
        
    } name:0];
    [_audioEngine setupAUWithComponentDescription:desc andCompletion:^(AUAudioUnit *unit) {
        
        au2 = unit;
        
        
    } name:1];
    
    [_audioEngine setupAUWithComponentDescription:desc andCompletion:^(AUAudioUnit *unit) {
        
        au3 = unit;
        [_audioEngine startEngine];
        
    } name:1];
    
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];
}


- (void)tapped:(UIPanGestureRecognizer *)recognizer {
    AUParameter * p = [au.parameterTree valueForKeyPath:@"frequency"];
    AUParameter * p2 = [au2.parameterTree valueForKeyPath:@"frequency"];
    AUParameter * p3 = [au3.parameterTree valueForKeyPath:@"frequency"];
    [p setValue: 440 originator:nil];
    [p2 setValue: 554 originator:nil];
    [p3 setValue: 659 originator:nil];
    
}

@end
