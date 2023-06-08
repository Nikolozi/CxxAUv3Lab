class CxxLabAudioUnit: CxxLabExtensionAudioUnit {
    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let k = Cxxke

        //let k = CxxLabExtensionDSPKernel()
        //k2.setParameter(0, 0.33)
        assert(self.kernel != nil)
       // let kernel = self.kernel.assumingMemoryBound(to: CxxLabExtensionDSPKernel.self).pointee //.load(as:
        //debugPrint(kernel.mGain)
        //CxxLabExtensionDSPKernel.self)
       // kernel.setParameter(0, 0.33)
    }
}
