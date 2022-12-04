{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  lspVimrcConfig = builtins.readFile ./base-neovim-config.lua;

  extraConfig = builtins.readFile ./extra-neovim-config.vim;

  vimrc = ''
    lua << EOF
    ${lspVimrcConfig}
    EOF

    ${extraConfig};
  '';

  # gruvbox-material color scheme
  gruvbox-material = pkgs.vimUtils.buildVimPlugin {
    name = "gruvbox-material";
    src = pkgs.fetchFromGitHub {
      owner = "sainnhe";
      repo = "gruvbox-material";
      rev = "af9a1d60ca4d7e2ca34c55c46d1dbea0769d9244";
      sha256 = "11lvqr8g9rwkpb768l2pc65j1r55lrb7410hbprca5qdcpz3n720";
    };
  };

  # bat.vim syntax highlighting:
  bat-vim = pkgs.vimUtils.buildVimPlugin {
    name = "bat.vim";
    src = pkgs.fetchFromGitHub {
      owner = "jamespwilliams";
      repo = "bat.vim";
      rev = "e2319b07ed6e74cdd70df2be6e8bf066377e22f7";
      sha256 = "0bmlvziha1crk7x7p1yzdsb55bvpsj434sc28r7xspin9kfnd6y9";
    };
  };

  overriden-neovim =
    pkgs.neovim.override {
      configure = {
        customRC = vimrc;
        packages.packages = with pkgs.vimPlugins; {
          start = [
            bat-vim
            gruvbox-material
            nvim-lspconfig
            (nvim-treesitter.withPlugins (
              plugins: with plugins; [
                tree-sitter-go
              ]
            ))
            sensible
          ];
        }; 
      };     
    };
in
mkShell {
  nativeBuildInputs = [
    go
    gopls
    overriden-neovim
    zsh-nix-shell
    tmux
    starship
  ];
}
