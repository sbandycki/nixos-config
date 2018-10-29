# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:



{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true; 

  # Use the GRUB 2 boot loader.
  boot.loader = {
  	grub.enable = true;
  	grub.version = 2;
  	grub.device = "nodev";
  	grub.efiSupport = true;
  	efi.canTouchEfiVariables = true;
  	grub.useOSProber = true;
  };

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1920x1080";


  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/c4d9f5f0-7494-4f75-8cbf-4c6e9934cdba";
      preLVM = true;
      allowDiscards = true;
    }
  ];


  networking.hostName = "lenux"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;


  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    };

  # Set your time zone.
    time.timeZone = "Europe/Warsaw";

  nixpkgs.config = {

  packageOverrides = pkgs: {
    
  #polybar = pkgs.polybar.override {
  #    alsaSupport = true;
  #    i3Support = true;
  #    iwSupport = true;
  #   githubSupport = true;
  #    mpdSupport = true;
  #};
    
  #  steam = pkgs.steam.override {
  #    withPrimus = true;
  #   extraPkgs = p: with p; [
  #      glxinfo        # for diagnostics
  #      nettools       # for `hostname`, which some scripts expect
  #      bumblebee      # for optirun
  #   ];
  #  };
  
  };




    allowUnfree = true;
    # allowBroken = true;
    # chromium.enablePepperFlash = true;
    # chromium.enablePepperPDF = true;
    # chromium.enableWideVine = true;
    # firefox.enableAdobeFlash = true;
    firefox.enablePepperFlash = true;
    # firefox.enableGoogleTalkPlugin = true;
   #  firefox.enableGnomeExtensions = true; 
	  };

  
  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Power 
  powerManagement.enable = true; 

  # Optimus
  hardware.bumblebee.enable = true;
  hardware.bumblebee.driver = "nvidia";
  # hardware.bumblebee.connectDisplay = true;
  boot.extraModprobeConfig = "bbswitch load_state=-1 unload_state=1";
  hardware.bumblebee.group = "video";


  # Use librsvg's gdk-pixbuf loader cache file as it enables gdk-pixbuf to load SVG files (important for icons)
  #   environment.sessionVariables = {
  #    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  # };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
   
    acpi
    acpitool
    adobe-reader
    android-udev-rules
    arandr
    hicolor-icon-theme
    adwaita-icon-theme
    papirus-icon-theme
    arc-theme
    arc-icon-theme
    arduino
    blueman
    breeze-icons
    calc
    cmus
    chromium
    # chrome-gnome-shell
    compton
    curl
    dmenu
    dunst
    enlightenment.terminology
    exfat
    feh
    firefox 
    gptfdisk
    gimp
    git
    glxinfo
    gparted
    gnome3.cheese
    go-mtpfs
    gnome3.adwaita-icon-theme
    gvfs
    gwenview
    htop
    imagemagick
    kcalc
    kate
    libreoffice
    lxappearance
    mesa 
    networkmanagerapplet
    ncdu
    neovim
    nitrogen
    ntfs3g
    nautilus
    xorg.xbacklight
    okular
    openjdk10
    pavucontrol
    pciutils
    # polybar
    python27Full
    python3Full
    python36Packages.neovim
    pythonPackages.pip
    ranger
    rofi
    scrot
    solaar
    sxiv
    # tilda
    tmux
    unzip
    udiskie
    
    # yakuake
    vanilla-dmz
    vdirsyncer
    #  vim_configurable
    vscode 
    wget
    which
    xfce.thunar
    xfce.thunar-volman
    xorg.xinit
    xorg.xmodmap
    vlc
    zip
    xorg.xhost
    xorg.xev
    
    # 3D modelling/printing
    freecad
    # repetier-host
    slic3r
    cura

  ];

  fonts.fonts = [ pkgs.source-code-pro pkgs.inconsolata ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  # programs.zsh.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  
  # List services that you want to enable:

  # Docker
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
 

  # steam
  users.users.seb.packages = [
    pkgs.steam
  ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;


  services = {

  # dbus.packages = [ pkgs.gnome3.gconf.out ];
  # needed by gtk apps
  # gnome3.at-spi2-core.enable = true;
  
  acpid.enable = true;
  # thermald.enable = true;
  tlp.enable = true;

  # Enable the OpenSSH daemon.
  openssh.enable = true;

  # Enable CUPS to print documents.
  printing.enable = true;
  printing.drivers = [ pkgs.hplip ];
  # printing.browsing = true;
  #  printing.listenAddresses = [ "*:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network


  # Enable automatic discovery of the printer from other Linux systems with avahi running.
  avahi.enable = true;
  # avahi.publish.enable = true;
  # avahi.publish.userServices = true;
  avahi.nssmdns = true;

  # custom udev packages
  udev.packages = [ pkgs.solaar pkgs.android-udev-rules ];

  xserver = {
  # Enable the X11 windowing system.
  enable = true;
  layout = "us";
  xkbOptions = "eurosign:e";
  videoDrivers = [ "intel" ];

  # Enable touchpad support.
  libinput = {
    enable = true;
    disableWhileTyping = true;
    naturalScrolling = false; # reverse scrolling
    scrollMethod = "twofinger";
    tapping = true;
    tappingDragLock = false;
  };

  # Enable Xmonad
  #windowManager.xmonad = { 
  #  enable = true;
  #  enableContribAndExtras = true;
  #  extraPackages = haskellPackages: [
  #  haskellPackages.xmonad-contrib
  #     haskellPackages.xmonad-extras
  #      haskellPackages.xmobar
  #      haskellPackages.xmonad
  #    ];
  #};

  # sets it as default
  # windowManager.default = "xmonad";
  # the plain xmonad experience  
  # desktopManager.default = "none";
  # xterm screen on start
  # desktopManager.xterm.enable = false;

  # Enable the KDE Desktop Environment.
  # displayManager.sddm.enable = true;
  # desktopManager.plasma5.enable = true;
  
  # Gdm
  #displayManager = {
  #  gdm.enable = true;
  #  gdm.wayland = false;
  #  gdm.autoLogin.enable = true;
  #  gdm.autoLogin.user = "seb";
  #	};
  
  # Gnome
  # desktopManager.gnome3.enable = true;

     
  # i3
    desktopManager.xterm.enable = false;
    windowManager.default = "i3";
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;
  
  
  # slim
  displayManager = {
    slim.enable = true;
    slim.autoLogin = true;
    slim.defaultUser = "seb";
   };
    

    };  
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraGroups.plugdev = { };
  users.extraUsers.seb = {
  isNormalUser = true;
  name = "seb";
  group = "users";
  createHome = true;
  home = "/home/seb";
  extraGroups = [ "wheel" "networkmanager" "docker" "video" "input" "plugdev" "dialout" ];
  shell = "/run/current-system/sw/bin/bash";
  uid = 1000;
  # initialPassword = "HelloWorld";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  # system.stateVersion = "18.03"; # Did you read the comment?
  system.autoUpgrade.enable = true;


}
