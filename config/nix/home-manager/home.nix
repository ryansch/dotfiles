{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ryansch";
  home.homeDirectory = "/Users/ryansch";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.zsh.enable = true;

  home.packages = [
    pkgs.gh
    pkgs.mkcert
    pkgs.bat
    pkgs.bat-extras.batgrep
    pkgs.bat-extras.batman
    pkgs.bat-extras.batpipe
    pkgs.bat-extras.batwatch
    pkgs.bat-extras.batdiff
    pkgs.bat-extras.prettybat
    pkgs.starship
    pkgs.hub
    #pkgs.git-delta
    pkgs.fzf
    pkgs.ripgrep
    pkgs.jq
    pkgs.neovim
    pkgs.git-lfs
    pkgs.fd
    pkgs.exa
    pkgs.zoxide

    pkgs.nodejs
    pkgs.tree-sitter
    pkgs.unzip

    pkgs.awscli2
    # pkgs._1password
    pkgs.kitty
    pkgs.bottom
  ];
}