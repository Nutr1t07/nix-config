{ pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  environment.systemPackages = with pkgs; [ nvidia-offload ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "dri_udev";
      text = ''
      ACTION=="add", KERNEL=="card*", SUBSYSTEM=="drm", TAG+="systemd"
      '';
      destination = "/etc/udev/rules.d/99-systemd-dri-devices.rules";
    })
  ];

  systemd.services.display-manager = {
    after = [ "dev-dri-card0.device" ];
    wants = [ "dev-dri-card0.device" ];
  };
}
