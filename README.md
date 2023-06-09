# CxxAUv3Lab
This repo is inspired by WWDC23. Using C++ with Swift to eliminate Objective-C code in Audio Unit Extension projects. I started with the Audio Unit Extension App template (instrument plug-in type) in Xcode 15 and slowly was able to fully remove Objective-C code. Obviously, this is not production-grade code. It has some obvious issues, but it's a proof of concept that we can reduce some boilerplate code to get DSP and UI to talk to each other.

I think it’s real-time safe, but maybe someone else can look at it and correct me. Hopefully, I can ask some questions about this at WWDC labs this week.

Check out the [Mixing Swift and C++](https://www.swift.org/documentation/cxx-interop/) document. It's well written. Also, the WWDC session [Mix Swift with C++](https://developer.apple.com/wwdc23/10172) goes with it.

I did add MacCatalyst support but I think there's some bug in Xcode 15 where it auto-generates code for Asset management and fails to compile. It's best to use it on an iOS device, inside AUM or another host.

If you have any feedback or questions let me know.

#### Core Audio Lab Feedback

During the Core Audio lab, Apple engineers had a quick look at the code (commit [0b9a715](https://github.com/Nikolozi/CxxAUv3Lab/commit/0b9a715aac8083558e245933bd307dd1deb88ab6)) and their main concern was around the contents of `internalRenderBlock` method. From the brief look, they said it looks correct and the best way to test its real-time safety is to use `auval` with the `-real-time-safety` flag. I'm on macOS 13.4 and Xcode 15.0 beta (15A5160n) and having issues getting it to create a release build, the compiler is crashing. I'll investigate it when I have more time.

