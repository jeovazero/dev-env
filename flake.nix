{
  description = "DEV";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }:
    let pkgsLinux = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShell = {
        x86_64-linux =  import ./shell.nix { pkgs = pkgsLinux; };
      };
    };
}
