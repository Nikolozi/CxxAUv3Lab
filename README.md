# CxxAUv3Lab
This repo is inspired by WWDC23. Using C++ with Swift to eliminate Objective-C code in Audio Unit Extension projects. I started with the Audio Unit Extension App template (instrument plug-in type) in Xcode 15 and slowly was able to fully remove Objective-C code. Obviously, this is not production-grade code. It has some obvious issues, but it's a proof of concept that we can reduce some boilerplate code to get DSP and UI to talk to each other.

I think it’s real-time safe, but maybe someone else can look at it and correct me. Hopefully, I can ask some questions about this at WWDC labs this week.

Check out the [Mixing Swift and C++](https://www.swift.org/documentation/cxx-interop/) document. It's well written. Also, the WWDC session [Mix Swift with C++](https://developer.apple.com/wwdc23/10172) goes with it.

I did add MacCatalyst support but I think there's some bug in Xcode 15 where it auto-generates code for Asset management and fails to compile. It's best to use it on an iOS device, inside AUM or another host.

If you have any feedback or questions let me know.
