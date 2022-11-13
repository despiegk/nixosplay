nix flake lock --update-input nixpkgs
nix build
nix flake check
git add . -A
git commit -a -m 'Initial version'
git push
