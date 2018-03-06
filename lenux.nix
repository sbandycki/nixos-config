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
	# chromium.enablePepperFlash = true;
 	# chromium.enablePepperPDF = true;
	# chromium.enableWideVine = true;
    	# firefox.enableAdobeFlash = true;
    	firefox.enablePepperFlash = true;
    	firefox.enableGoogleTalkPlugin = true;
	};

  hardware.pulseaudio.enable = true;  

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     wget vim curl zsh htop ntfs3g okular zip unzip stack vscode chromium firefox terminology gimp git cmus rofi source-code-pro feh compton
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable Xmonad
  # windowManager.xmonad.enable = true;
  # installs xmonad and makes it available
  # windowManager.xmonad.enableContribAndExtras = true;
  # makes xmonad-contrib and xmonad-extras available
  # windowManager.default       = "xmonad";
  # sets it as default
  # desktopManager.default      = "none";
  # the plain xmonad experience  


  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  
  # Gnome
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  
  # i3
  services.xserver.windowManager.i3.enable = true;
  
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.seb = {
  isNormalUser = true;
  name = "seb";
  group = "users";
  createHome = true;
  home = "/home/seb";
  extraGroups = [ "wheel" "networkmanager"];
  shell = "/run/current-system/sw/bin/bash";
  uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
