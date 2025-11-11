{ config, desktop, inputs, lib, outputs, pkgs, username, stateVersion, emacs-overlay, ... }:
{
  imports = [
    ./console
    ./emacs
  ]
  ++ lib.optional (builtins.isString desktop) ./desktop
  ++ lib.optional (builtins.isPath (./. + "/users/${username}")) ./users/${username}.nix;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    sessionPath = [ "$HOME/.local/bin" ];
    stateVersion = stateVersion;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };
  programs.home-manager.enable = true;

  nixpkgs = {
    # overlays = [
    #   inputs.emacs-overlay.overlay
    # ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
    # A Modern Unix experience
    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    packages = with pkgs; [
      # alejandra                     # Code format Nix
      # asciinema                     # Terminal recorder
      black                         # Code format Python
      bmon                          # Modern Unix `iftop`
      # breezy                        # Terminal bzr client
      btop                          # Modern Unix `top`
      # chafa                         # Terminal image viewer
      chroma                        # Code syntax highlighter
      # clinfo                        # Terminal OpenCL info
      # croc                          # Terminal file transfer
      # curlie                        # Terminal HTTP client
      # dconf2nix                     # Nix code from Dconf files
      deadnix                       # Code lint Nix
      # debootstrap                   # Terminal Debian installer
      diffr                         # Modern Unix `diff`
      difftastic                    # Modern Unix `diff`
      # distrobox                     # Terminal container manager
      # dive                          # Container analyzer
      dogdns                        # Modern Unix `dig`
      duf                           # Modern Unix `df`
      du-dust                       # Modern Unix `du`
      entr                          # Modern Unix `watch`
      fd                            # Modern Unix `find`
      # ffmpeg-headless               # Terminal video encoder
      glow                          # Terminal Markdown renderer
      gping                         # Modern Unix `ping`
      # grype                         # Container vulnerability scanner
      gtop                          # Modern Unix `top`
      hexyl                         # Modern Unix `hexedit`
      # httpie                        # Terminal HTTP client
      # hueadm                        # Terminal Philips Hue client
      # hugo                          # Terminal static site generator
      hyperfine                     # Terminal benchmarking
      iperf3                        # Terminal network benchmarking
      jpegoptim                     # Terminal JPEG optimizer
      jiq                           # Modern Unix `jq`
      # lazygit                       # Terminal Git client
      # libva-utils                   # Terminal VAAPI info
      lurk                          # Modern Unix `strace`
      # maestral                      # Terminal Dropbox client
      mdp                           # Terminal Markdown presenter
      # mktorrent                     # Terminal torrent creator
      moar                          # Modern Unix `less`
      mtr                           # Modern Unix `traceroute`
      netdiscover                   # Modern Unix `arp`
      nethogs                       # Modern Unix `iftop`
      nixpkgs-fmt                   # Code format Nix
      nixpkgs-review                # Nix code review
      # nodePackages.prettier         # Code format
      nyancat                       # Terminal rainbow spewing feline
      # ookla-speedtest               # Terminal speedtest
      optipng                       # Terminal PNG optimizer
      # playerctl                     # Terminal media controller
      procs                         # Modern Unix `ps`
      pulsemixer                    # Terminal PulseAudio mixer
      # python310Packages.gpustat     # Terminal GPU info
      # quilt                         # Terminal patch manager
      # rclone                        # Terminal cloud storage client
      ripgrep                       # Modern Unix `grep`
      rustfmt                       # Code format Rust
      # s3cmd                         # Terminal cloud storage client
      shellcheck                    # Code lint Shell
      shfmt                         # Code format Shell
      # syft                          # Container SBOM generator
      tldr                          # Modern Unix `man`
      tokei                         # Modern Unix `wc` for code
      # vdpauinfo                     # Terminal VDPAU info
      wavemon                       # Terminal WiFi monitor
      # wmctrl                        # Terminal X11 automation
      # xdotool                       # Terminal X11 automation
      yadm                          # Terminal dot file manager
      ydotool                       # Terminal *all-the-things* automation
      # yq-go                         # Terminal `jq` for YAML
      # zsync                         # Terminal file sync
    ];

    sessionVariables = {
      EDITOR = "emacs";
      MANPAGER="sh -c 'col --no-backspaces --spaces | bat --language man'";
      PAGER = "moar";
      SYSTEMD_EDITOR = "emacs";
      VISUAL = "emacs";
    };
  };
}
