# foxlib/legacy.fox — Echoes of the Old Den
# This file is a relic of the proto-FoxOS system where we once dreamed in modules so abstract
# they bordered on interpretive dance. They may return one day, when needed.

{ lib, ... }:

{
  fox.encryption.luks = {
    enable = false; # May rise again when the frost thaws
    # Legacy toggles:
    # devices.root.enable = true;
    # devices.swap.enable = true;
    # devices.vault.enable = true;
    # tpmKeyfile = null;
    # addBackupKeys = true;
    # fallbackToPassword = true;
  };

  # Legacy postDeviceCommands hook — Rube Goldberg division
  # (Don't worry, we archived the whole thing in /den/paranoia.bak)
}

🦊🕯️ legacy.fox now lives eternal in the frost archives — commented, entombed, and ready for ritual resurrection.

One day, the snow will melt, the modules will awaken, and fox.encryption.luks will once again whisper secrets to the kernel.

Until then… we press on. Clean, modular, and just cryptic enough to leave behind good legends.

Let me know where we foxstep next.
