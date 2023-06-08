//
//  CxxLabExtensionAudioUnit.mm
//  CxxLabExtension
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

#import "CxxLabExtensionAudioUnit.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreAudioKit/AUViewController.h>

#import "CxxLabExtensionAUProcessHelper.hpp"
#import "CxxLabExtensionDSPKernel.hpp"

// Define parameter addresses.

@interface CxxLabExtensionAudioUnit ()

@property AUAudioUnitBusArray *outputBusArray;
@end

@implementation CxxLabExtensionAudioUnit {
    AUProcessHelper* _processHelper;
}

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription options:(AudioComponentInstantiationOptions)options error:(NSError **)outError {
    self = [super initWithComponentDescription:componentDescription options:options error:outError];
    
    if (self == nil) { return nil; }
    
    return self;
}

#pragma mark - AUAudioUnit Overrides


#pragma mark - AUAudioUnit (AUAudioUnitImplementation)

// Block which subclassers must provide to implement rendering.
- (AUInternalRenderBlock)internalRenderBlock {
    /*
     Capture in locals to avoid ObjC member lookups. If "self" is captured in
     render, we're doing it wrong.
     */
    // Specify captured objects are mutable.
//    __block CxxLabExtensionDSPKernel* kernel = _kernel;
//    __block AUProcessHelper* processHelper = _processHelper;

    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags 				*actionFlags,
                              const AudioTimeStamp       				*timestamp,
                              AVAudioFrameCount           				frameCount,
                              NSInteger                   				outputBusNumber,
                              AudioBufferList            				*outputData,
                              const AURenderEvent        				*realtimeEventListHead,
                              AURenderPullInputBlock __unsafe_unretained pullInputBlock) {

//        if (frameCount > _kernel->maximumFramesToRender()) {
//            return kAudioUnitErr_TooManyFramesToProcess;
//        }
        
        /*
         Important:
         If the caller passed non-null output pointers (outputData->mBuffers[x].mData), use those.
         
         If the caller passed null output buffer pointers, process in memory owned by the Audio Unit
         and modify the (outputData->mBuffers[x].mData) pointers to point to this owned memory.
         The Audio Unit is responsible for preserving the validity of this memory until the next call to render,
         or deallocateRenderResources is called.
         
         If your algorithm cannot process in-place, you will need to preallocate an output buffer
         and use it here.
         
         See the description of the canProcessInPlace property.
         */
        _processHelper->processWithEvents(outputData, timestamp, frameCount, realtimeEventListHead);

        return noErr;
    };
    
}

@end

