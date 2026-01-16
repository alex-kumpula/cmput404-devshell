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

          # Required for many pip packages to compile correctly on Nix
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ];

        shellHook = ''
          VENV=.venv
          if [ ! -d "$VENV" ]; then
            echo "Creating new venv..."
            python -m venv "$VENV"
          fi

          source "$VENV/bin/activate"
          
          # Fix for C-libraries in pip-installed packages
          export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:$LD_LIBRARY_PATH"
          
          echo "Python virtual environment activated!"
          python --version
        '';
      };
    };
}