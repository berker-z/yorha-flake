{
  description = "yorha grub theme by OliveThePuffin";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib;
  in {
    nixosModules.yorha-grub-theme = {
      config,
      pkgs,
      ...
    }: let
      cfg = config.boot.loader.grub.yorhaTheme;

      theme = pkgs.stdenv.mkDerivation {
        pname = "yorha-grub-theme";
        version = "1.0";
        src = self;
        installPhase = ''
          mkdir -p $out/share/grub/themes/yorha
          cp -r ${cfg.resolution}/* $out/share/grub/themes/yorha/
        '';
        meta = with lib; {
          description = "yorha grub theme (${cfg.resolution})";
          homepage = "https://github.com/OliveThePuffin/yorha-grub-theme";
          license = licenses.mit;
        };
      };
    in {
      options.boot.loader.grub.yorhaTheme = {
        enable = lib.mkEnableOption "yorha grub theme";
        resolution = lib.mkOption {
          type = lib.types.enum ["1080p" "1440p"];
          default = "1080p";
          description = "which resolution variant to install";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [theme];
        boot.loader.grub.theme = "${theme}/share/grub/themes/yorha";
      };
    };
  };
}
