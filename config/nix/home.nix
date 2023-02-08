{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ryansch";
  home.homeDirectory = "/home/ryansch";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.gh
    pkgs.mkcert
    pkgs.bat
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

    pkgs.ruby_3_1
    pkgs.nodejs
    pkgs.tree-sitter
    pkgs.unzip
  ];
}
