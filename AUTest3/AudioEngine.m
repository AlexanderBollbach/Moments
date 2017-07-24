//
//  AudioEngine.m
//  AUInstrument
//
//  Created by Eric on 4/19/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "AudioEngine.h"

@interface AudioEngine() {
    AVAudioEngine *_engine;
    AVAudioUnit *_synthNode;
    AVAudioFormat *hardwareFormat;
}
@end

@implementation AudioEngine

- (instancetype) init {
    if (self = [super init]) {
        [self initAVAudioSession];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:(NSString *)kAudioComponentInstanceInvalidationNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            AUAudioUnit *auAudioUnit = (AUAudioUnit *)note.object;
            NSValue *val = note.userInfo[@"audioUnit"];
            AudioUnit audioUnit = (AudioUnit)val.pointerValue;
            NSLog(@"Received kAudioComponentInstanceInvalidationNotification: auAudioUnit %@, audioUnit %p (Crash?)", auAudioUnit, audioUnit);
        }];
        _engine = [[AVAudioEngine alloc] init];
        
        hardwareFormat = [_engine.outputNode outputFormatForBus:0];
        [_engine connect:[_engine mainMixerNode] to:[_engine outputNode] format:hardwareFormat];
    }
    return self;
}

- (void) setupAUWithComponentDescription:(AudioComponentDescription)componentDescription andCompletion:(completedAUSetup) completion name:(int)name {

    [AVAudioUnit instantiateWithComponentDescription:componentDescription
                                             options:kAudioComponentInstantiation_LoadOutOfProcess
                                   completionHandler:^ (AVAudioUnit * __nullable unit, NSError * __nullable error) {
         [_engine attachNode:unit];
         
         AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:hardwareFormat.sampleRate channels:2];
         [_engine connect:unit to:[_engine mainMixerNode] format:stereoFormat];

         printf("name: %i pointer: %p \n", name, unit.AUAudioUnit);

         completion(unit.AUAudioUnit);
     }];
}

- (void)startEngine {
    if (!_engine.isRunning) {
        NSError *error;
        BOOL success;
        success = [_engine startAndReturnError:&error];
        NSAssert(success, @"couldn't start engine, %@", [error localizedDescription]);
    }
}
- (void)initAVAudioSession {
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!success) {
        NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    }
    success = [sessionInstance setActive:YES error:&error];
    if (!success) {
        NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
    }
}

@end

