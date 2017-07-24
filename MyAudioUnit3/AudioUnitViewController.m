//
//  AudioUnitViewController.m
//  MyAudioUnit3
//
//  Created by Alexander Bollbach on 7/23/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import "AudioUnitViewController.h"
#import "MyAudioUnit3.h"

@interface AudioUnitViewController ()

@end

@implementation AudioUnitViewController {
    AUAudioUnit *audioUnit;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (!audioUnit) {
        return;
    }
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
}

- (AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc error:(NSError **)error {
    audioUnit = [[MyAudioUnit3 alloc] initWithComponentDescription:desc error:error];
    
    return audioUnit;
}

@end
