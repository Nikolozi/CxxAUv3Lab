class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    private var helper = AUProcessHelper.create()

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)

        setKernel(helper.kernel)
    }

    override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        helper.kernel.setMusicalContextBlock(musicalContextBlock)
    }

    override var internalRenderBlock: AUInternalRenderBlock {
        let helper = self.helper

        return { actionFlags, timestamp, frameCount, outputBusNumber, outputData, realtimeEventListHead, pullInputBloc  in

            guard frameCount <=  helper.kernel.maximumFramesToRender() else {
                return kAudioUnitErr_TooManyFramesToProcess;
            }

            helper.processWithEvents(outputData, timestamp, frameCount, realtimeEventListHead)

            return noErr
        }
    }

    deinit {
        AUProcessHelper.destroy(helper)
    }
}
