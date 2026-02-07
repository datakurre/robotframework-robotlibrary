{ pkgs, ... }:
let
  shell = { pkgs, lib, config, ... }: {

    # -- Python development environment --
    languages.python = {
      enable = true;
      venv = {
        enable = true;
        requirements = ''
          -e .
          build
          twine
        '';
      };
    };

    # -- Nix tooling --
    languages.nix.enable = true;

    # -- Additional packages --
    packages = with pkgs; [
      gnumake
    ];

    # -- Git hooks for code quality --
    git-hooks.hooks = {
      ruff.enable = true;
      ruff-format.enable = true;
      check-toml.enable = true;
      check-yaml.enable = true;
    };

    # -- MCP server for AI-assisted development --
    claude.code.mcpServers.devenv = {
      type = "stdio";
      command = "devenv";
      args = [ "mcp" ];
      env = {
        DEVENV_ROOT = config.devenv.root;
      };
    };

    # -- Development tasks --
    tasks = {
      "dev:test" = {
        exec = "python -m robot --outputdir output tests/test_*.robot";
      };
      "dev:libdoc" = {
        exec = "python -m robot.libdoc RobotLibrary RobotLibrary.html";
      };
    };

    # -- Release tasks --
    tasks."release:build" = {
      exec = ''
        rm -rf dist/
        python -m build
      '';
    };
    tasks."release:check" = {
      exec = "python -m twine check dist/*";
    };
    tasks."release:publish-test" = {
      exec = "python -m twine upload --repository testpypi dist/*";
    };
    tasks."release:publish" = {
      exec = "python -m twine upload dist/*";
    };
  };
in
{
  profiles.shell.module = {
    imports = [ shell ];
  };

  profiles.devcontainer.module = {
    devcontainer.enable = true;
  };
}
