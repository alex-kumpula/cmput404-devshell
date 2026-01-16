{
  description = "A simple Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (pkgs.python311.withPackages (python-pkgs: [
            python-pkgs.pandas
            python-pkgs.requests
          ]))
        ];

        shellHook = ''
          echo "Entered a Python development shell!"
          python --version
        '';
      };
    };
}