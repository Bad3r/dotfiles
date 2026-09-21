# TODO List

Nothing open.

The repository deploys nothing, so configuration work belongs in the
[`Bad3r/nixos`](https://github.com/Bad3r/nixos) flake. That closes the four items that stood here: setting up dotbot
and completing its config (dotbot and `z-install.conf.yml` are gone), reviewing another repository's zsh setup and
moving the zsh and nix config out (Home Manager owns zsh in `modules/shell/zsh/` of the flake, and df8a3aa removed
the tree here), and tracking `/etc/udisks2/mount_options.conf` (a file tracked here reaches no machine; declare the
setting in the flake).
