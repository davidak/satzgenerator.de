# generated using pypi2nix tool (version: 1.8.0)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -v -V 3.5 -r requirements.txt
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python35;
  };

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python35-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs);
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "PyMySQL" = python.mkDerivation {
      name = "PyMySQL-0.7.11";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/29/f8/919a28976bf0557b7819fd6935bfd839118aff913407ca58346e14fa6c86/PyMySQL-0.7.11.tar.gz"; sha256 = "56e3f5bcef6501012233620b54f6a7b8a34edc5751e85e4e3da9a0d808df5f68"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = licenses.mit;
        description = "Pure Python MySQL Driver";
      };
    };



    "PyZufall" = python.mkDerivation {
      name = "PyZufall-0.13.2";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/e9/29/0da2eea28f42f984fdbf9219270bd311572a7f89496a360de82b5912881e/PyZufall-0.13.2.tar.gz"; sha256 = "659160f36e3d909330ceb4df48f3d4ecbbd9db6216ca858e6b4ea00a4484cec9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."future"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = "";
        description = "";
      };
    };



    "SQLAlchemy" = python.mkDerivation {
      name = "SQLAlchemy-1.1.9";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/02/69/9473d60abef55445f8e967cfae215da5de29ca21b865c99d2bf02a45ee01/SQLAlchemy-1.1.9.tar.gz"; sha256 = "b65cdc73cd348448ef0164f6c77d45a9f27ca575d3c5d71ccc33adf684bc6ef0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."PyMySQL"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = licenses.mit;
        description = "Database Abstraction Library";
      };
    };



    "bottle" = python.mkDerivation {
      name = "bottle-0.12.13";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/bd/99/04dc59ced52a8261ee0f965a8968717a255ea84a36013e527944dbf3468c/bottle-0.12.13.tar.gz"; sha256 = "39b751aee0b167be8dffb63ca81b735bbf1dd0905b3bc42761efedee8f123355"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = licenses.mit;
        description = "Fast and simple WSGI-framework for small web-applications.";
      };
    };



    "future" = python.mkDerivation {
      name = "future-0.16.0";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"; sha256 = "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "";
        license = licenses.mit;
        description = "Clean single-source support for Python 3 and 2";
      };
    };

  };
  overrides = import ./requirements_override.nix { inherit pkgs python; };
  commonOverrides = [

  ];

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            ([overrides] ++ commonOverrides)
         )
   )