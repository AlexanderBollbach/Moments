//
//  MyAudioUnit3AudioUnit.m
//  MyAudioUnit3
//
//  Created by Alexander Bollbach on 7/23/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

#import "MyAudioUnit3.h"
#import <AVFoundation/AVFoundation.h>

typedef struct FreqParam {
    float value;
} FreqParam;

@interface MyAudioUnit3 ()
@property (nonatomic, readwrite) AUParameterTree *parameterTree;
@property AUAudioUnitBusArray *outputBusArray;
@property (nonatomic, assign) FreqParam * freqParam;
@end

@implementation MyAudioUnit3 {
    float * freqTest;
}
@synthesize parameterTree = _parameterTree;

AudioBufferList renderABL;
AUAudioUnitBus *_outputBus; // was BufferedInputBus in sample code
AVAudioPCMBuffer* pcmBuffer;


AudioBufferList const* originalAudioBufferList;
const AudioUnitParameterID frequencyAddress = 0;



- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription options:(AudioComponentInstantiationOptions)options error:(NSError **)outError {
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    if (self == nil) { return nil; }
    
    FreqParam * freqParam = malloc(sizeof(FreqParam));
    freqParam->value = 200;
    
    self.freqParam = freqParam;
    
    float a = 22;
    freqTest = &a;
    
    
    
    
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
    param1.value = 201;
    
    _parameterTree = [AUParameterTree createTreeWithChildren:@[ param1 ]];

    
    __block float * freqVal = freqTest;
    
    _parameterTree.implementorValueProvider = ^(AUParameter *param) {
        
        MyAudioUnit3 * selfP = self;
        
        FreqParam * freqParam = self.freqParam;
        
        switch (param.address) {
            case frequencyAddress:
                
                return *freqVal;
//                return (AUValue)freqParam->value;
                
            default:
                return (AUValue) 0.0;
        }
    };
    

    
    
    _parameterTree.implementorValueObserver = ^(AUParameter *param, AUValue value) {
        
        FreqParam * freqParam = self.freqParam;
        MyAudioUnit3 * selfP = self;
        
        *freqVal = 4;
        
        switch (param.address) {
            case frequencyAddress:
                *freqVal = value;
                freqParam->value = value;
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


- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError {
    
    if (![super allocateRenderResourcesAndReturnError:outError]) { return NO; }
    renderABL.mNumberBuffers = 2; // this is actually needed
    pcmBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:_outputBus.format frameCapacity: 512];
    originalAudioBufferList = pcmBuffer.audioBufferList;
    return YES;
}

- (void)deallocateRenderResources { [super deallocateRenderResources]; }

void prepareOutputBufferList(AudioBufferList* outBufferList, AVAudioFrameCount frameCount, bool zeroFill) {
    UInt32 byteSize = frameCount * sizeof(float);
    for (UInt32 i = 0; i < outBufferList->mNumberBuffers; ++i) {
        outBufferList->mBuffers[i].mNumberChannels = originalAudioBufferList->mBuffers[i].mNumberChannels;
        outBufferList->mBuffers[i].mDataByteSize = byteSize;
        if (outBufferList->mBuffers[i].mData == NULL) {
            outBufferList->mBuffers[i].mData = originalAudioBufferList->mBuffers[i].mData;
        }
        if (zeroFill) { memset(outBufferList->mBuffers[i].mData, 0, byteSize); }
    }
}

#pragma mark - AUAudioUnit (AUAudioUnitImplementation)
- (AUInternalRenderBlock)internalRenderBlock {

    FreqParam * freqParam = self.freqParam;

    __block float phase = 0.0;
    
    
    AUValue *frequencyCapture = freqTest;

    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags, const AudioTimeStamp *timestamp, AVAudioFrameCount frameCount, NSInteger outputBusNumber, AudioBufferList *outputData, const AURenderEvent *realtimeEventListHead, AURenderPullInputBlock pullInputBlock) {
        
        prepareOutputBufferList(outputData, frameCount, true);

        float* outL = (float*)outputData->mBuffers[0].mData;
        float* outR = (float*)outputData->mBuffers[1].mData;

        float freq1 = freqParam->value;

        float freq2 = *frequencyCapture;
        
        float phaseIncrement = freq2 * (3.14159 * 3.0) / 44100;
        
        for (int frame = 0; frame < frameCount; frame++) {
            outL[frame] = outR[frame] = sin(  phase  );
            phase += phaseIncrement;
        }
        return noErr;
    };
};

@end
