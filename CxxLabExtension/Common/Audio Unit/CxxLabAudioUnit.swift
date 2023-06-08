class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    private let kernel = CxxLabExtensionDSPKernel.create()
    private var helper: AUProcessHelper!

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)

        setKernel(kernel)

        kernel.setParameter(0, 0.33)
        debugPrint(kernel.mGain)
    }

    override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        helper = AUProcessHelper.create(kernel)
        setProcessHelper(helper)
    }

    deinit {
        CxxLabExtensionDSPKernel.destroy(kernel)
        AUProcessHelper.destroy(helper)
    }
}
