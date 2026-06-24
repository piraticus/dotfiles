# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

 let
   emacs-everforest-theme = pkgs.callPackage ./customPackages/emacs-everforest.nix {};
 in

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "tortega-5690-nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma"; # or "plasmawayland" if you want it to be the default
  services.desktopManager.plasma6.enable = true;
  hardware.nvidia.powerManagement.enable = true; # For NVIDIA GPUs
  
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.groups.plugdev = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tony = {
    isNormalUser = true;
    description = "Tony";
    extraGroups = [ "networkmanager" "wheel" "plugdev" "dialout"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  nix.settings.trusted-users = ["root" "tony"];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     emacs
     vscode.fhs
     unzip
     kitty
     clang-tools
     swaybg
     wlogout
     hyprlock
     wofi
     waybar
     swaynotificationcenter
     swaybg
     fuzzel
     killall
     networkmanager
     networkmanagerapplet
     fzf
     vivaldi
     python3Packages.python-lsp-server
     python3
     mermaid-cli
     grim
     slurp
     wl-clipboard
     meld
     libreoffice
     kdePackages.kcalc
     emacs-everforest-theme
     everforest-gtk-theme
     everforest-cursors
     kdePackages.knewstuff
     nwg-look
     wine-wayland
     pavucontrol
     brightnessctl
     calibre
  ];

  programs.steam = {
    enable = true;
  };
  programs.gamemode.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;


  services.displayManager.sddm.settings = {
    General = {
      Numlock = "on";
    };
  };

  # Enable Logitech hardware support and Solaar GUI
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # This implicitly enables the solaar service

  services.udisks2.enable = true;
  
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
