{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.htop
	  pkgs.neovim
          pkgs.python311
          pkgs.poetry
        ];

      # Homebrew
      homebrew = {
        enable = true;
        casks = [
          "rectangle"
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
      };
      homebrew.onActivation.autoUpdate = true;
      homebrew.onActivation.cleanup = "zap";
      # Yabai
      # services.yabai.enable = true;
      # services.yabai.config = {
      #   layout = "bsp";
      #   focus_follows_mouse = "autoraise";
      #   mouse_follows_focus = "off";
      #   window_placement    = "second_child";
      #   window_opacity      = "off";
      #   window_gap          = 0;
      # };
      # services.yabai.extraConfig = ''
      #   yabai -m config external_bar all:32:0
      # '';


      system.defaults = {
        dock.autohide = false;
        NSGlobalDomain._HIHideMenuBar = false;
        # dock.mru-spaces = false;
        # finder.AppleShowAllExtensions = true;
        # finder.FXPreferredViewStyle = "clmv";
        # loginwindow.LoginwindowText = "nixcademy.com";
        # screencapture.location = "~/Pictures/screenshots";
        # screensaver.askForPasswordDelay = 10;
      };

      # Sketchy Bar
      # services.sketchybar.enable = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Enable TouchID for sudo:
      security.pam.enableSudoTouchIdAuth = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Fonts
      fonts = {
        fontDir.enable = true;
        fonts = with pkgs; [
          (nerdfonts.override {fonts = ["FantasqueSansMono"];})
        ];
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
