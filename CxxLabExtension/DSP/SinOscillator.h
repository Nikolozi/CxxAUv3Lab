//
//  SinOscillator.h
//  CxxLabExtension
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

#pragma once

#include <numbers>
#include <cmath>

class SinOscillator {
public:
    SinOscillator(double sampleRate = 44100.0) {
        mSampleRate = sampleRate;
    }

    void setFrequency(double frequency) {
        mDeltaOmega = frequency / mSampleRate;
    }

    double process() {
        const double sample = std::sin(mOmega * (std::numbers::pi_v<double> * 2.0));
        mOmega += mDeltaOmega;

        if (mOmega >= 1.0) { mOmega -= 1.0; }
        return sample;
    }

private:
    double mOmega = { 0.0 };
    double mDeltaOmega = { 0.0 };
    double mSampleRate = { 0.0 };
};
