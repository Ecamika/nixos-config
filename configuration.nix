# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/a" = {
    device = "/dev/disk/by-uuid/49716208-797c-41e8-8a5b-456ee8d73718";
    fsType = "ext4";
    #options = [ "uid=1000" "gid=100" "umask=022" ];
  };

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=65535
  '';

  networking.hostName = "EcNixPC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ecamika = {
    isNormalUser = true;
    description = "Ecamika";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  home-manager.users.ecamika = { pkgs, config, ... }: {
    home.stateVersion = "26.05";

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      fastfetch
      xwayland-satellite
      libnotify
      mako
      swaylock-effects
      waypaper
      qq
      alsa-utils
      alsa-firmware
      netease-cloud-music-gtk
      osdlyrics
      v2rayn
      kilocode-cli
      opencode
      mission-center
      yazi
      reaper
      gcr
    ];

    xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;
    xdg.configFile."mako/config".source = ./dotfiles/mako/config;
    xdg.configFile."swaylock/config".source = ./dotfiles/swaylock/config;
    xdg.configFile."kitty/current-theme.conf".source = ./dotfiles/kitty/Nord.conf;
    xdg.configFile."gtk-3.0/settings.ini".source = ./dotfiles/gtk-3.0/settings.ini;
    home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./dotfiles/fcitx5/rime/default.custom.yaml;

    programs.fuzzel.enable = true;
    programs.kitty = {
      enable = true;
      settings = {
        include = "./current-theme.conf";
        font_family = "Maple Mono NF CN";
        bold_font = "Maple Mono NF CN Bold";
        italic_font = "Maple Mono NF CN Italic";
        bold_italic_font = "Maple Mono NF CN Bold Italic";
        font_size = 10;
        background_opacity = 0.75;
        background_blur = 1;
        dynamic_background_opacity = true;
      };
    };
    programs.waybar = {
      enable = true;
    };

    programs.thunderbird = {
      enable = true;
      languagePacks = [ "zh-CN" ];
    };

    services.copyq.enable = true;

    services.awww.enable = true;

    services.gnome-keyring.enable = true;


    programs.firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
    };

    programs.vscode = {
      enable = true;
    };

    programs.git = {
      enable = true;
      settings.user = {
        name = "Ecamika";
        email = "index@ecamika.dev";
      };
      settings.init.defaultBranch = "main";
    };

    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        testnw = "ping www.baidu.com";
        os-switch = "sudo nixos-rebuild switch --log-format bar-with-logs";
      };

      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.zsh_history";
      history.ignorePatterns = [ "rm *" "pkill *" "cp *" ];

      initContent = ''
        fastfetch
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "z"
          "sudo"
        ];
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./dotfiles/p10k-config;
          file = "p10k.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
        }
      ];
    };
  };

  programs.steam.enable = true;

  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.niri.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  services.tumbler.enable = true;

  security.soteria.enable = true;

  services.gvfs.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "ecamika";
      };
    };
  };

  systemd.user.services.niri.enableDefaultPath = false;

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    powerManagement.enable = true;
  };

  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.alsa.enable = true;

  # system.userActivationScripts.zshrc = "touch .zshrc";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nh # Nix Helper
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  fonts.packages = with pkgs; [
    maple-mono.NF-CN-unhinted
  ];

  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Maple Mono NF CN";
        package = pkgs.maple-mono.NF-CN-unhinted;
      }
    ];
    extraOptions = "--font-size 16";
    term = "xterm-256color";
    # extraConfig = ''
    #   hwaccel
    #   mouse
    # '';
  };

  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # qinghua university mirrors
    ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  };
}
