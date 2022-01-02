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
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://hydra.iohk.io"
  ];
  nixpkgs.config.allowUnfree = true;

#  systemd.services.nix-daemon.environment = {
#    http_proxy = "http://127.0.0.1:10809/";
#    https_proxy = "http://127.0.0.1:10809/"; 
#  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  time.timeZone = "Asia/Shanghai";


  location = {
    provider = "manual";
    latitude = 23.0;
    longitude = 116.0;
  };

  networking = {
    hostName = "hasee-nixos";
    defaultGateway = "192.168.0.3";
    nameservers = [ "192.168.0.3" "8.8.8.8" ];
    dhcpcd.extraConfig = ''
      interface enp2s0f1
      static ip_address=192.168.0.123/24	
      static routers=192.168.0.3
      static domain_name_servers=192.168.0.3 8.8.8.8
    '';
    networkmanager.enable = true;
    interfaces.enp2s0f1.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };

  i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
      inputMethod.enabled = "fcitx5";
      inputMethod.fcitx5.addons = [ pkgs.fcitx5-rime pkgs.fcitx5-chinese-addons pkgs.fcitx5-configtool ];
  };

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.enable = true;

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  users.users.ne1s07 = {
    description = "Ne1s07 X";
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "vboxusers" ];
  };

   ## VitrualBox
   virtualisation.virtualbox.host.enable = true;
   virtualisation.virtualbox.host.enableExtensionPack = true;
   users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  environment.systemPackages = with pkgs; [
    # tool
    calibre
    gimp
    ffmpeg
    scrcpy

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
    rxvt_unicode
    neofetch
    tree
    unrar
    unzip
    ntfs3g
    zlib
    jre
    kfind
    nix-index
    fzf
    p7zip
    rpPPPoE
    python37
    

    # editor
    vimHugeX
    vim
    vscode-fhs
    emacs

    # programming
    stack
    gcc
    niv

    # health
    workrave
   
    # media
    mpv
    ranger

    # gaming
    lutris

    wineWowPackages.stable
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libpng
      ];
    };
  };
  
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
        theme = "ys";
        plugins = [ "git" "man" "extract"];
      };
    };
    bash.enableCompletion = true;
    dconf.enable = true;
    adb.enable = true;
    steam.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  services = {
    tlp.enable = true;
    ## blueman.enable = true;
    ## redshift.enable = true;
  };

  system.stateVersion = "21.11";
  system.autoUpgrade.enable = true;
}

