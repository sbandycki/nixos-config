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
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1920x1080";


  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/blkid";
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
    defaultLocale = "en_IE.UTF-8";
    };

  # Set your time zone.
    time.timeZone = "Europe/Dublin";

  nixpkgs.config = {
 
    allowUnfree = true;
    # allowBroken = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;
    # chromium.enableWideVine = true;
    # firefox.enableAdobeFlash = true;
    firefox.enablePepperFlash = true;
    firefox.enableGoogleTalkPlugin = true;
    firefox.enableGnomeExtensions = true;
	  };

  
  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  # Power 
  powerManagement.enable = true;  

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    arandr
    cmus
    chromium
    chrome-gnome-shell
    curl
    dmenu
    firefox 
    freecad
    gimp
    git
    glxinfo
    htop  
    libreoffice
    mesa 
    networkmanagerapplet
    ncdu
    ntfs3g
    okular
    ranger
    rofi
    solaar
    tilda
    tmux
    unzip
    unrar
    vim
    vscode 
    wget
    which
    vlc
    zip
    zsh
  ];

  fonts.fonts = [ pkgs.source-code-pro ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.zsh.enableCompletion = true;
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

  services = {

    dbus.packages = [ pkgs.gnome3.gconf.out ];
  # needed by gtk apps
    gnome3.at-spi2-core.enable = true;
  
  acpid.enable = true;
  # thermald.enable = true;
  tlp.enable = true;

  # Enable the OpenSSH daemon.
  openssh.enable = true;

  # Enable CUPS to print documents.
  printing.enable = true;
  printing.drivers = [ pkgs.hplip ];
  printing.browsing = true;
  printing.listenAddresses = [ "*:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network

  # Enable automatic discovery of the printer from other Linux systems with avahi running.
  avahi.enable = true;
  avahi.publish.enable = true;
  avahi.publish.userServices = true;

  xserver = {
  # Enable the X11 windowing system.
  enable = true;
  layout = "gb";
  xkbOptions = "eurosign:e";
  # videoDrivers = [ "nvidia" ];

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
  # displayManager = {
  #	gdm.enable = true;
  # gdm.wayland = false;
  #	gdm.autoLogin.enable = true;
  #	gdm.autoLogin.user = "seb";
  #	};
  
  # Gnome
  # desktopManager.gnome3.enable = true;

     
  # i3
   services.xserver.desktopManager.xterm.enable = false;
   services.xserver.windowManager.default = "i3";
   services.xserver.windowManager.i3.enable = true;
   services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  
  
  # slim
    displayManager = {
    slim.enable = true;
    slim.autoLogin = true;
    slim.defaultUser = "seb";
   };
    

    };  
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.seb = {
  isNormalUser = true;
  name = "seb";
  group = "users";
  createHome = true;
  home = "/home/seb";
  extraGroups = [ "wheel" "networkmanager" "docker"];
  shell = "/run/current-system/sw/bin/bash";
  uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
