//
//  AudioEngine.h
//  AUTest3
//
//  Created by Alexander Bollbach on 7/23/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//
@import Foundation;
@import AVFoundation;

@interface AudioEngine : NSObject

@property(nonatomic, assign)AudioUnit synth;

typedef void(^completedAUSetup)(AUAudioUnit * unit);
- (void) setupAUWithComponentDescription:(AudioComponentDescription)componentDescription andCompletion:(completedAUSetup) completion name:(int)name;
- (void)startEngine;
@end
