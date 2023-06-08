//
//  CxxLabExtensionAUProcessHelper.hpp
//  CxxLabExtension
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

#pragma once

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import <swift/bridging>

#include <vector>
#include "CxxLabExtensionDSPKernel.hpp"

//MARK:- AUProcessHelper Utility Class
class AUProcessHelper
{
public:
    CxxLabExtensionDSPKernel* _Nonnull kernel;

    AUProcessHelper(CxxLabExtensionDSPKernel* _Nonnull kernel, UInt32 outputChannelCount)
    : mKernel{kernel},
    mOutputBuffers(outputChannelCount) {
    }

    static AUProcessHelper *_Nonnull create() {
        auto kernel = CxxLabExtensionDSPKernel::create();
        AUProcessHelper* obj = new AUProcessHelper(kernel, kernel->_outputChannelCount);
        obj->kernel = kernel;
        return obj;
    }

    static void destroy(AUProcessHelper *_Nonnull obj) {
        CxxLabExtensionDSPKernel::destroy(obj->kernel);
        delete obj;
    }

    /**
     This function handles the event list processing and rendering loop for you.
     Call it inside your internalRenderBlock.
     */
    void processWithEvents(AudioBufferList* outBufferList, AudioTimeStamp const *timestamp, AUAudioFrameCount frameCount, AURenderEvent const * _Nullable events) {
        
        AUEventSampleTime now = AUEventSampleTime(timestamp->mSampleTime);
        AUAudioFrameCount framesRemaining = frameCount;
        AURenderEvent const *nextEvent = events; // events is a linked list, at the beginning, the nextEvent is the first event
        
        auto callProcess = [this] (AudioBufferList* outBufferListPtr, AUEventSampleTime now, AUAudioFrameCount frameCount, AUAudioFrameCount const frameOffset) {
            for (int channel = 0; channel < mOutputBuffers.size(); ++channel) {
                mOutputBuffers[channel] = (float*)outBufferListPtr->mBuffers[channel].mData + frameOffset;
            }
            
            mKernel->process(mOutputBuffers, now, frameCount);
        };
        
        while (framesRemaining > 0) {
            // If there are no more events, we can process the entire remaining segment and exit.
            if (nextEvent == nullptr) {
                AUAudioFrameCount const frameOffset = frameCount - framesRemaining;
                callProcess(outBufferList, now, framesRemaining, frameOffset);
                return;
            }
            
            // **** start late events late.
            auto timeZero = AUEventSampleTime(0);
            auto headEventTime = nextEvent->head.eventSampleTime;
            AUAudioFrameCount framesThisSegment = AUAudioFrameCount(std::max(timeZero, headEventTime - now));
            
            // Compute everything before the next event.
            if (framesThisSegment > 0) {
                AUAudioFrameCount const frameOffset = frameCount - framesRemaining;
                callProcess(outBufferList, now, framesThisSegment, frameOffset);
                
                // Advance frames.
                framesRemaining -= framesThisSegment;
                
                // Advance time.
                now += AUEventSampleTime(framesThisSegment);
            }
            
            nextEvent = performAllSimultaneousEvents(now, nextEvent);
        }
    }
    
    AURenderEvent const * performAllSimultaneousEvents(AUEventSampleTime now, AURenderEvent const *event) {
        do {
            mKernel->handleOneEvent(now, event);
            
            // Go to next event.
            event = event->head.next;
            
            // While event is not null and is simultaneous (or late).
        } while (event && event->head.eventSampleTime <= now);
        return event;
    }

private:
    CxxLabExtensionDSPKernel* mKernel;
    std::vector<float*> mOutputBuffers;
} SWIFT_UNSAFE_REFERENCE;
