{ package ? "parser-learning", compiler ? "ghc822" }:
let fetchNixpkgs = import ./nix/fetchNixpkgs.nix;
    nixpkgs = fetchNixpkgs {
      rev = "eb857611378576f96022867a9fd15a7a841e518c";
      sha256 = "0gnlxsmc7gi06dqlij1bgmcias83isldrvydw4688qpm8h4wdf44"; 
      sha256unpacked = "02ddlyc2i9l96hsm3l2g02vrv7ljl4h5vbnqfq4p2xvm6zb5v0q6";
    };
    pkgs = import nixpkgs { config = {}; overlays = []; };
    inherit (pkgs) haskell;
  
  filterPredicate = p: type:
    let path = baseNameOf p; in !(
       (type == "directory" && path == "dist")
    || (type == "symlink"   && path == "result")
    || (type == "directory" && path == ".git")
    || (type == "symlink"   && pkgs.lib.hasPrefix "result" path)
    || pkgs.lib.hasSuffix "~" path
    || pkgs.lib.hasSuffix ".o" path
    || pkgs.lib.hasSuffix ".so" path
    || pkgs.lib.hasSuffix ".nix" path);
    
  overrides = haskell.packages.${compiler}.override {
    overrides = self: super:
    with haskell.lib;
    with { cp = file: (self.callPackage (./nix/haskell + "/${file}.nix") {}); 
           build = name: path: self.callCabal2nix name (builtins.filterSource filterPredicate path) {}; 
         };

    {
      #mkDerivation = args: super.mkDerivation (args // {
      #  doCheck = pkgs.lib.elem args.pname [ "parser-learning" ]; 
      #  doHaddock = false;
      #});
      
      parser-learning = overrideCabal (build "parser-learning" ./.) (drv: {
        doBenchmark = false;
        doCheck     = false;
        doHaddock   = false;
      });   
    };
  };
in rec {
  drv = overrides.${package};
  parser-learning = if pkgs.lib.inNixShell then drv.env else drv;
}
