//
//  CxxLabExtensionAUProcessHelper.cpp
//  CxxLabExtension
//
//  Created by Josip Cavar on 10.01.2024..
//

#include "CxxLabExtensionAUProcessHelper.hpp"

AUInternalRenderBlock makeInternalRenderBlock(AUProcessHelper* _Nonnull helper) {
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags                 *actionFlags,
                              const AudioTimeStamp                       *timestamp,
                              AVAudioFrameCount                           frameCount,
                              NSInteger                                   outputBusNumber,
                              AudioBufferList                            *outputData,
                              const AURenderEvent                        *realtimeEventListHead,
                              AURenderPullInputBlock __unsafe_unretained pullInputBlock) {

        if (frameCount > helper->kernel->maximumFramesToRender()) {
            return kAudioUnitErr_TooManyFramesToProcess;
        }

        helper->processWithEvents(outputData, timestamp, frameCount, realtimeEventListHead);

        return noErr;
    };
}
