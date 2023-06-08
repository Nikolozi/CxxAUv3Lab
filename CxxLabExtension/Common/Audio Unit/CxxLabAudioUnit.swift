class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    private let kernel = CxxLabExtensionDSPKernel.create()
    private var helper: AUProcessHelper!

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)

        setKernel(kernel)
    }

    override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        helper = AUProcessHelper.create(kernel)
        kernel.setMusicalContextBlock(musicalContextBlock)
        setProcessHelper(helper)
    }

    override var internalRenderBlock: AUInternalRenderBlock {
        #warning("capturing self here, need to deal with it at some point.")

        return { [weak self] actionFlags, timestamp, frameCount, outputBusNumber, outputData, realtimeEventListHead, pullInputBloc  in
            guard let self, let helper = self.helper else { return noErr }

            guard frameCount <=  self.kernel.maximumFramesToRender() else {
                return kAudioUnitErr_TooManyFramesToProcess;
            }

            helper.processWithEvents(outputData, timestamp, frameCount, realtimeEventListHead)

            return noErr
        }
    }

    deinit {
        CxxLabExtensionDSPKernel.destroy(kernel)
        AUProcessHelper.destroy(helper)
    }
}
