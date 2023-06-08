class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    private let kernel = CxxLabExtensionDSPKernel.create()

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)



        //let k = CxxLabExtensionDSPKernel()
        kernel.setParameter(0, 0.33)
        assert(self.kernel != nil)
       // let kernel = self.kernel.assumingMemoryBound(to: CxxLabExtensionDSPKernel.self).pointee //.load(as:
        debugPrint(kernel.mGain)
        //CxxLabExtensionDSPKernel.self)
       // kernel.setParameter(0, 0.33)
    }

    deinit {
        CxxLabExtensionDSPKernel.destroy(kernel)
    }
}
