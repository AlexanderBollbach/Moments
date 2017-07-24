//
//  MyAudioUnit3AudioUnit.m
//  MyAudioUnit3
//
//  Created by Alexander Bollbach on 7/23/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import "MyAudioUnit3.h"

#import <AVFoundation/AVFoundation.h>



@interface MyAudioUnit3 ()

@property (nonatomic, readwrite) AUParameterTree *parameterTree;
@property AUAudioUnitBusArray *outputBusArray;
@end


@implementation MyAudioUnit3

@synthesize parameterTree = _parameterTree;


AudioBufferList renderABL;
AUAudioUnitBus *_outputBus; // was BufferedInputBus in sample code
AVAudioPCMBuffer* pcmBuffer;

AUValue frequency = 200;
id pointerToSelf;

AudioBufferList const* originalAudioBufferList;

// Define parameter addresses.
const AudioUnitParameterID frequencyAddress = 0;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription options:(AudioComponentInstantiationOptions)options error:(NSError **)outError {
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    
    
    if (self == nil) { return nil; }
    
    pointerToSelf = self;
    
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable |
    kAudioUnitParameterFlag_IsReadable;
    
    // Create parameter objects.
    AUParameter *param1 = [AUParameterTree createParameterWithIdentifier:@"frequency"
                                                                    name:@"Frequency"
                                                                 address:frequencyAddress
                                                                     min:100
                                                                     max:1000
                                                                    unit:kAudioUnitParameterUnit_Hertz
                                                                unitName:nil
                                                                   flags:flags
                                                            valueStrings:nil
                                                     dependentParameters:nil];
    param1.value = 200;
    
    _parameterTree = [AUParameterTree createTreeWithChildren:@[ param1 ]];
    

    
    
    // implementorValueProvider is called when the value needs to be refreshed.
    param1.implementorValueProvider = ^(AUParameter *param) {
        switch (param.address) {
            case frequencyAddress:
                return frequency; // TODO: is this capturing self?
            default:
                return (AUValue) 0.0;
        }
    };
    
    
    
    
    
    // implementorValueObserver is called when a parameter changes value.
    param1.implementorValueObserver = ^(AUParameter *param, AUValue value) {
        
        
        
        switch (param.address) {
            case frequencyAddress:
                printf("%p \n", pointerToSelf);
                frequency = value;
                break;
            default:
                break;
        }
    };
    
    AVAudioFormat *defaultFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100.0 channels:2];
    
    _outputBus = [[AUAudioUnitBus alloc] initWithFormat:defaultFormat error:nil];
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
    
    self.maximumFramesToRender = 512;
    
    return self;
}



- (AUAudioUnitBusArray *)outputBusses { return _outputBusArray; }

// Subclassers should call the superclass implementation.
- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError {
    
    if (![super allocateRenderResourcesAndReturnError:outError]) {
        return NO;
    }
    
    renderABL.mNumberBuffers = 2; // this is actually needed

    pcmBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:_outputBus.format frameCapacity: 512];
    
    originalAudioBufferList = pcmBuffer.audioBufferList;
    
    return YES;
}

// Deallocate resources allocated in allocateRenderResourcesAndReturnError:
// Subclassers should call the superclass implementation.
- (void)deallocateRenderResources {
    // Deallocate your resources.
    [super deallocateRenderResources];
}

void prepareOutputBufferList(AudioBufferList* outBufferList, AVAudioFrameCount frameCount, bool zeroFill)
{
    UInt32 byteSize = frameCount * sizeof(float);
    for (UInt32 i = 0; i < outBufferList->mNumberBuffers; ++i)
    {
        outBufferList->mBuffers[i].mNumberChannels = originalAudioBufferList->mBuffers[i].mNumberChannels;
        outBufferList->mBuffers[i].mDataByteSize = byteSize;
        if (outBufferList->mBuffers[i].mData == NULL)
        {
            outBufferList->mBuffers[i].mData = originalAudioBufferList->mBuffers[i].mData;
        }
        if (zeroFill)
        {
            memset(outBufferList->mBuffers[i].mData, 0, byteSize);
        }
    }
}

#pragma mark - AUAudioUnit (AUAudioUnitImplementation)

// Block which subclassers must provide to implement rendering.
- (AUInternalRenderBlock)internalRenderBlock {

    AUValue * param1Capture = &frequency;
    __block float phase = 0.0;
    
    

    
    
    // Capture in locals to avoid Obj-C member lookups. If "self" is captured in render, we're doing it wrong. See sample code.
    
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags, const AudioTimeStamp *timestamp, AVAudioFrameCount frameCount, NSInteger outputBusNumber, AudioBufferList *outputData, const AURenderEvent *realtimeEventListHead, AURenderPullInputBlock pullInputBlock) {
        
        prepareOutputBufferList(outputData, frameCount, true);
        
        float* outL = (float*)outputData->mBuffers[0].mData;
        float* outR = (float*)outputData->mBuffers[1].mData;
        
        
        
        float phaseIncrement = *param1Capture * (3.14159 * 2.0) / 44100;
        
        for (int frame = 0; frame < frameCount; frame++) {
            outL[frame] = outR[frame] = sin(  phase  );
            phase += phaseIncrement;
        }
        return noErr;
    };
};


@end

