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

@implementation MyAudioUnit3 {
    float frequency;
    AudioBufferList const * originalAudioBufferList;
    AVAudioPCMBuffer* pcmBuffer;
    AUAudioUnitBus *_outputBus;
    AudioBufferList renderABL;
}
@synthesize parameterTree = _parameterTree;





const AudioUnitParameterID frequencyAddress = 0;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription options:(AudioComponentInstantiationOptions)options error:(NSError **)outError {
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    if (self == nil) { return nil; }
    
    AudioUnitParameterOptions flags = kAudioUnitParameterFlag_IsWritable |
    kAudioUnitParameterFlag_IsReadable;
    
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
    param1.value = 500;
    
    
    
    _parameterTree = [AUParameterTree createTreeWithChildren:@[ param1 ]];
    
    
    
    
    __weak MyAudioUnit3 * weak = self;
    
    _parameterTree.implementorValueProvider = ^(AUParameter *param) {
        
        __strong MyAudioUnit3 * strong = weak;
        
        switch (param.address) {
            case frequencyAddress:
                return (AUValue)strong->frequency;
            default:
                return (AUValue) 0.0;
        }
    };
    
    _parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) {
        
        __strong MyAudioUnit3 * strong = weak;
        
        switch (param.address) {
                
            case frequencyAddress:
                
                strong->frequency = value;
                break;
            default:
                break;
        }
    };
    
    
    AVAudioFormat *defaultFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100.0 channels:2];
    
    _outputBus = [[AUAudioUnitBus alloc] initWithFormat:defaultFormat error:nil];
    _outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
    
//    self.maximumFramesToRender = 512;
    
    return self;
}

- (AUAudioUnitBusArray *)outputBusses { return _outputBusArray; }


- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError {
    
    if (![super allocateRenderResourcesAndReturnError:outError]) { return NO; }
    renderABL.mNumberBuffers = 2; // this is actually needed
    pcmBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:_outputBus.format frameCapacity: 1024];
    originalAudioBufferList = pcmBuffer.audioBufferList;
    return YES;
}

- (void)deallocateRenderResources { [super deallocateRenderResources]; }

void prepareOutputBufferList(AudioBufferList* outBufferList, AVAudioFrameCount frameCount, bool zeroFill, AudioBufferList const * originalAudioBufferList) {
    
    UInt32 byteSize = frameCount * sizeof(float);
    
    int numberOfOutputBuffers = outBufferList->mNumberBuffers;
    
    for (int i = 0; i < numberOfOutputBuffers; ++i) {
        
        outBufferList->mBuffers[i].mNumberChannels = originalAudioBufferList->mBuffers[i].mNumberChannels; // copies num channels
        
        outBufferList->mBuffers[i].mDataByteSize = byteSize; // and how many bytes
        
        if (outBufferList->mBuffers[i].mData == NULL) {
            outBufferList->mBuffers[i].mData = originalAudioBufferList->mBuffers[i].mData;
        }
        
        if (zeroFill) { memset(outBufferList->mBuffers[i].mData, 0, byteSize); }
    }
}

#pragma mark - AUAudioUnit (AUAudioUnitImplementation)
- (AUInternalRenderBlock)internalRenderBlock {
    
   
    AUValue * frequencyCapture = &frequency;
    
    AudioBufferList const ** originalABLCapture = &originalAudioBufferList;
    
    __block float phase = 0.0;
    
    float deltaTime = 1.0 / 44100;
    
    float SR = 44100;
    
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags, const AudioTimeStamp *timestamp, AVAudioFrameCount frameCount, NSInteger outputBusNumber, AudioBufferList *outputData, const AURenderEvent *realtimeEventListHead, AURenderPullInputBlock pullInputBlock) {
        
        
        
        AudioBufferList const * oABL = *originalABLCapture;
        prepareOutputBufferList(outputData, frameCount, true, oABL);
        
        // buffers
        float* outL = (float*)outputData->mBuffers[0].mData;
        float* outR = (float*)outputData->mBuffers[1].mData;
        
        
        float freq = *frequencyCapture;
  
        
        double phaseIncrement = 2 * M_PI * freq / SR;

        
        
        for (int frame = 0; frame < frameCount; frame++) {
     
            
   
            float val = sin(phase);

            phase = phase + phaseIncrement;
            
            if (phase >= (2 * M_PI)) {
                phase = phase - (2 * M_PI);
            }


   
            

            outL[frame] = val;
            outR[frame] = val;
   
        }
        

        
        
//        printf("hit");
        return noErr;
    };
};

@end
