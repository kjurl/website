{ pkgs, lib, config, inputs, ... }: {
  # devenv info
  # https://devenv.sh/basics/
  env = {
    DEVENV_STATUS = "ok";
    DIRENV_WARN_TIMEOUT = "100s";
  };

  # https://devenv.sh/packages/
  packages = with pkgs; [
    just
    lazygit
    vercel-pkg
  ];
  # https://devenv.sh/integrations/dotenv/
  dotenv = {
    enable = true;
    filename = ".env.local";
  };

  # https://devenv.sh/languages/
  languages = {
    python = {
      enable = true;
      version = "3.12";
      # lsp.enable = true;
      poetry = {
        enable = true;
        activate.enable = true;
        install = {
          enable = true;
          quiet = true;
          allExtras = true;
          installRootPackage = true;
        };
      };
    };
    javascript = {
      enable = true;
      package = pkgs.nodejs_22;
      pnpm = {
        enable = true;
        install.enable = true;
      };
    };
    typescript.enable = true;
  };


  # https://devenv.sh/creating-files/
  files.".npmrc".text = ''
    strict-peer-dependencies=false
    auto-install-peers = true

    # Expose Astro dependencies for \`pnpm\` users
    shamefully-hoist=true
    ignore-workspace-root-check = true
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    shellcheck.enable = true;

    fix-byte-order-marker.enable = true;
    check-case-conflicts.enable = true;
    check-json.enable = true;
    check-toml.enable = true;
    check-yaml.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
    mixed-line-endings.enable = true;
    check-added-large-files.enable = true;

    poetry-check.enable = true;
    poetry-lock.enable = true;
    uv-check.enable = true;
    uv-lock.enable = true;

    pnpm-check = {
      enable = true;
      name = "pnpm-check";
      entry = "bash -c 'pnpm doctor'";
      pass_filenames = false;
    };
    pnpm-lock = {
      enable = true;
      name = "pnpm-lock";
      entry = "bash -c 'pnpm install --lockfile-only'";
      pass_filenames = false;
    };

    add-dot-to-requirements = {
      enable = true;
      name = "add-dot-to-requirements";
      entry = ''
        bash -c '[ -f ./requirements.txt ] && [ "$(tail -c 1 ./requirements.txt)" = "." ] && echo "." >> ./requirements.txt || exit 0'
      '';
      files = "requirements\\.txt$";
      pass_filenames = false;
    };

    lint-staged = {
      enable = true;
      name = "lint-staged";
      entry = "bash -c 'pnpm lint-staged'";
      language = "system";
      pass_filenames = true;
    };

    biome.enable = true;
    black.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
