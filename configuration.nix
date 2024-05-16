{self, pkgs, ...}:
{

      # Hide dock and menu bar:
      system.defaults = {
        dock.autohide = true;
        NSGlobalDomain._HIHideMenuBar = false;
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Enable TouchID for sudo:
      security.pam.enableSudoTouchIdAuth = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";


      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      environment.systemPackages =
        with pkgs; [
          vim
          htop
          neovim
          python311
          python311Packages.pip
          nodejs_22
          poetry
          tmux
          wget
          tree-sitter
        ];
    # Fonts
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        (nerdfonts.override {fonts = ["FantasqueSansMono" "Hack"];})
        font-awesome_5
      ];
    };

      # Homebrew
      homebrew = {
        enable = true;
        casks = [
          "visual-studio-code"
          "protonvpn"
          "google-chrome"
          "docker"
          "1password"
          "dbeaver-community"
          "kitty"
          "slack"
          "zed"
          "brave-browser"
          "firefox"
          "obsidian"
          "warp"
          "brave-browser"
          "proton-drive"
          "pdf-expert"
        ];
        brews = [
        # Postgresql  16
        "ca-certificates"
        "icu4c"
        "lz4"
        "postgresql@16"
        "xz"
        "gettext"
        "krb5"
        "openssl@3"
        "readline"
        "zstd"
        ];
        taps = [
          "homebrew/services"
        ];
        onActivation = {
          autoUpdate = true;
          cleanup = "zap";
        };
      };


      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
}
