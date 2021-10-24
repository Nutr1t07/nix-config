{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./display.nix
    ];
  nix.trustedUsers = [ "root" "@wheel" ];

  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];

  nix.binaryCaches = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://hydra.iohk.io"
  ];
  nixpkgs.config.allowUnfree = true;

  systemd.services.nix-daemon.environment = {
    http_proxy = "http://127.0.0.1:10809/";
    https_proxy = "http://127.0.0.1:10809/"; 
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  time.timeZone = "Asia/Shanghai";

  networking = {
    hostName = "hasee-nixos";
    networkmanager.enable = true;
    interfaces.enp2s0f1.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };

  i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
      inputMethod.enabled = "fcitx5";
      inputMethod.fcitx5.addons = [ pkgs.fcitx5-rime pkgs.fcitx5-configtool ];
  };
  
  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  users.users.ne1s07 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    # tool
    calibre
    gimp

    # network
    wget
    proxychains
    v2ray
    w3m
    git
    aria2

    # web
    firefox
    chromium
    qutebrowser
    thunderbird

    # social
    tdesktop

    # system tool
    neofetch
    tree
    unrar
    unzip
    ntfs3g
    zlib
    jre
    kfind
    nix-index

    # editor
    vimHugeX
    vim
    vscode-fhs

    # programming
    stack
    gcc
    haskell-language-server
    niv

    # health
    workrave
   
    # media
    mpv
  ];
  
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts.emoji = [ "Noto Color Emoji" ];
      defaultFonts.monospace = [ "Hack" "Sarasa Mono SC" ];
      defaultFonts.sansSerif = [ "Inter" "Liberation Sans" "Soruce Han Sans SC" ];
      defaultFonts.serif = [ "Liberation Serif" "Source Han Serif SC" ];
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      hack-font
      inter
      liberation_ttf
      noto-fonts-emoji
      roboto
      sarasa-gothic
      source-han-mono
      source-han-sans
      source-han-sans-simplified-chinese
      source-han-serif
      source-han-serif-simplified-chinese
      symbola
      wqy_microhei
      wqy_zenhei
    ];
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins = [ "git" "python" "man" "extract"];
      };
    };
    bash.enableCompletion = true;
    dconf.enable = true;
    # steam.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  services = {
    tlp.enable = true;
    blueman.enable = true;
  };

  system.stateVersion = "21.05";
  system.autoUpgrade.enable = false;
}

