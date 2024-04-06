{
  pkgs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix ../laptop.nix];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #  boot = {
  #     initrd.kernelModules = [
  #       "vfio_pci"
  #       "vfio"
  #       "vfio_iommu_type1"

  #       "kvmfr"

  #       # "vfio_virqfd"

  #       # "nvidia"
  #       # "nvidia_modeset"
  #       # "nvidia_uvm"
  #       # "nvidia_drm"
  #     ];

  #     extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];

  #     kernelParams = [
  #       # enable IOMMU
  #       "intel_iommu=on"

  #       # isolate the GPU
  #       "vfio-pci.ids=01:00.0,01:00.1"

  #       "kvmfr.static_size_mb=64"
  #     ];
  #   };

  # virtualisation.spiceUSBRedirection.enable = true;

  # virtualisation.libvirtd = {
  #   # Pin host processes to E-cores
  #   hooks.qemu = { win11 = ./qemu-pin-host-e-cores.sh; };
  # };

  networking.hostName = "x16";

  services.asusd.enable = true;

  environment.systemPackages = with pkgs; [asusctl];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # boot.extraModprobeConfig = ''
  #   blacklist nouveau
  #   options nouveau modeset=0
  # '';

  # services.udev.extraRules = ''
  #   # Remove NVIDIA USB xHCI Host Controller devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA USB Type-C UCSI devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA Audio devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA VGA/3D controller devices
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  # '';
  # boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # services.udev.extraRules = ''
  #   ACTION=="add", KERNEL=="0000:32:00.0", SUBSYSTEM=="pci", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:32:00.0/remove'"
  # '';

  # boot.blacklistedKernelModules = [ "xhci_hcd", "sdhci-pci" ];
}
