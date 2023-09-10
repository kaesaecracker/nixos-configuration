{lib, ...}: {
  mkIfElse = p: yes: no:
    lib.mkMerge [
      (mkIf p yes)
      (mkIf (!p) no)
    ];
}
