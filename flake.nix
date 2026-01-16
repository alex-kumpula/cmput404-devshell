{
  description = "A simple Python development environment";

  inputs = {
    # Points to the stable NixOS package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems to support
      system = "x86_64-linux"; # Use "aarch64-darwin" for Apple Silicon Macs
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # Packages to include in the shell
        buildInputs = [
          (pkgs.python3.withPackages (python-pkgs: [
            python-pkgs.pandas
            python-pkgs.requests
          ]))
        ];

        # Commands to run when the shell starts
        shellHook = ''
          echo "Welcome to your Python dev environment!"
          python --version
        '';
      };
    };
}