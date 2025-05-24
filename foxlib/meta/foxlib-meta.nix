# .foxfiles/frostfall/foxlib/foxlib-meta.nix
{ ... }:{
 foxlib.meta = {
    identity = {
      system = "FoxOS";
      framework = "Frostfall";
    };

    version = {
      name = "0.1-zetaOmnicron";
      stage = "pre-Alpha";
    };

    authors = [
      "Commander Fox"
      "GeneralPT"
      "Director Gemini"
      "TheDeepSeeker"
    ];

    cliTools = [
      "foxctl"
      "foxcfg"
      "fox"
      "fx"
      "foxfix"
      "vulpes"
    ];

    systemProfiles = {
      frostnix = "minimal hardened base";
      foxnix = "standard user system";
      foxnix-plus = "extended system with extras";
      ...
      foxcorp = "enterprise workstation";
      fox-dev = "developer tools enabled";
      admin-fox = "privileged admin console";
      [host]-[user] = "per-user specific, employee";
      guest-fox = "limited access profile";
      ...
      foxstudio = "multimedia/DAW setup";
      foxlabs = "experimental build";
      fox-server = "selfhosting, homelabs;"
      virtual-fox = "virtual managers, clouds;"
      cyberfox = "cybersecurity, pentesting";
      ghostfox = "invisible, no-trace"
      mysticfox = "AI/themed, esoteric mythos,";
      illuminatedfox = "ssshhhhh, unspoken";
      ...
      desktop-[default] = "live user session";
      live-demo = "showcase presentation mode";
      kiosk = "locked down shell, bestbuy mode";
      ...
    };
  };
}
    
