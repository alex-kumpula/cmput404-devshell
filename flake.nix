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
          pkgs.python311

          # Required for many pip packages to compile correctly on Nix
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ];

        shellHook = ''
          VENV=.venv

          # Create venv if it doesn't exist
          if [ ! -d "$VENV" ]; then
            echo "Creating new venv at $VENV..."
            python -m venv "$VENV"
          fi
          
          # Enter the venv
          source "$VENV/bin/activate"
          
          # Fix for C-libraries in pip-installed packages
          export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:$LD_LIBRARY_PATH"

          # Install the packages in a requirements.txt if there is one
          if [ -d "requirements.txt" ]; then
            echo "Found requirements.txt, running pip install..."
            python -m pip install -r requirements.txt
            echo "Requirements installed!"
          fi
          
          echo "Python virtual environment activated!"
          python --version
        '';
      };
    };
}