//
//  CxxLabExtensionParameterAddresses.h
//  CxxLabExtension
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

#pragma once

#include <AudioToolbox/AUParameters.h>

#ifdef __cplusplus
namespace CxxLabExtensionParameterAddress {
#endif

typedef NS_ENUM(AUParameterAddress, CxxLabExtensionParameterAddress) {
    gain = 0
};

#ifdef __cplusplus
}
#endif
