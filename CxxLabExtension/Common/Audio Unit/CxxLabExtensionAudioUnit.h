//
//  CxxLabExtensionAudioUnit.h
//  CxxLabExtension
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface CxxLabExtensionAudioUnit : AUAudioUnit

- (void)setKernel:(id)kernel;

- (void)setupParameterTree:(AUParameterTree *)parameterTree;
@end
