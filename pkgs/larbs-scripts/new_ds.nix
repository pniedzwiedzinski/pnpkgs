{ callPackage, lib, buildEnv }:
let
  mapCase = options:
  builtins.concatStringsSep "\n"
  (builtins.map
  (option: "\t\"${option}\") ${builtins.getAttr option options} ;;")
  (builtins.attrNames options));

in

lib.makeOverridable (
  { moreOptions ? {} }:
  let
    voidrice = callPackage ../voidrice.nix { };
    dmenu = callPackage ../dmenu { };
  in
  buildEnv {
    name = "displayselect";

    paths = [
      dmenu
    ];

    postBuild = ''
      echo '${mapCase moreOptions}' > $out/bin/test
      cp ${voidrice}/.local/bin/displayselect $out/bin
    '';

  })
