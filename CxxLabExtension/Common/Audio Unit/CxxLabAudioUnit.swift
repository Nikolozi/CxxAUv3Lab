class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    private var helper = AUProcessHelper.create()

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)

        setKernel(helper.kernel)
    }

    override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        helper.kernel.setMusicalContextBlock(musicalContextBlock)
        let outputChannelCount = self.outputBusses[0].format.channelCount
        let sampleRate = outputBus.format.sampleRate
        helper.kernel.initialize(Int32(outputChannelCount), sampleRate)
    }

    override func deallocateRenderResources() {
        helper.kernel.deInitialize()
        super.deallocateRenderResources()
    }

    override var maximumFramesToRender: AUAudioFrameCount {
        set { helper.kernel.setMaximumFramesToRender(newValue) }
        get { helper.kernel.maximumFramesToRender() }
    }

    override var shouldBypassEffect: Bool {
        set { helper.kernel.setBypass(newValue) }
        get { helper.kernel.isBypassed() }
    }

    override var audioUnitMIDIProtocol: MIDIProtocolID {
        helper.kernel.AudioUnitMIDIProtocol()
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

extension CxxLabAudioUnit {
    func setupParameterTree(_ parameterTree: AUParameterTree) {
        self.parameterTree = parameterTree

        for parameter in parameterTree.allParameters {
            helper.kernel.setParameter(parameter.address, parameter.value)
        }

        setupParameterCallbacks(parameterTree)
    }
}

private extension CxxLabAudioUnit {
    func setupParameterCallbacks(_ parameterTree: AUParameterTree) {
        // Make a local pointer to the kernel to avoid capturing self.
        let kernel = helper.kernel

        // implementorValueObserver is called when a parameter changes value.
        parameterTree.implementorValueObserver = { parameter, value in
            kernel.setParameter(parameter.address, value)
        }

        // implementorValueProvider is called when the value needs to be refreshed.
        parameterTree.implementorValueProvider = { parameter in
            kernel.getParameter(parameter.address);
        };

        // A function to provide string representations of parameter values.
        parameterTree.implementorStringFromValueCallback = { parameter, value in
            let v = value?.pointee == nil ? value!.pointee : parameter.value
            return "\(v)"
        };
    }
}
