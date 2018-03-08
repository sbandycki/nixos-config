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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; 


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
    consoleKeyMap = "uk";
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

  hardware.pulseaudio.enable = true;
  powerManagement.enable = true;  

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    cmus
    chromium
    chrome-gnome-shell
    curl
    firefox 
    freecad
    gimp
    git
    htop  
    libreoffice
    mesa 
    networkmanagerapplet
    ncdu
    ntfs3g
    okular
    ranger
    rofi
    source-code-pro
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
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

  xserver = {
  # Enable the X11 windowing system.
  enable = true;
  layout = "uk";
  xkbOptions = "eurosign:e";

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
  windowManager.xmonad = { 
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmobar
        haskellPackages.xmonad
      ];
  };
  # sets it as default
  # windowManager.default       = "xmonad";
  # the plain xmonad experience  
  # desktopManager.default      = "none";

  # Enable the KDE Desktop Environment.
  # displayManager.sddm.enable = true;
  # desktopManager.plasma5.enable = true;
  
  # Gdm
  displayManager = {
  	  gdm.enable = true;
  	  gdm.wayland = false;
  	  gdm.autoLogin.enable = true;
  	  gdm.autoLogin.user = "seb";
  	};
  
  # Gnome
  desktopManager.gnome3.enable = true;
  
  
  # slim
  # displayManager = {
  #   slim.enable = true;
  #   slim.autoLogin = true;
  #   slim.defaultUser = "seb";
  #   };
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
