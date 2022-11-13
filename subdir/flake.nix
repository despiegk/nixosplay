{
  description = "A flake for building Hello World";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "hello2";
        src = self;
        buildPhase = "cd subdir;ls;gcc -o hello2 hello2.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello2";
      };

  };
}