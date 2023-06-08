class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    private let kernel = CxxLabExtensionDSPKernel.create()

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)

        setKernel(kernel)

        kernel.setParameter(0, 0.33)
        debugPrint(kernel.mGain)
    }

    deinit {
        CxxLabExtensionDSPKernel.destroy(kernel)
    }
}
