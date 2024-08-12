(_final: prev: {
  kanata = prev.callPackage ./kanata {};
  kanata-kext = prev.callPackage ./kanata { withKarabinerKext = true; };
})
