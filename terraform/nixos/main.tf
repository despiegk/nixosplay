terraform {
  required_providers {
    grid = {
      source = "threefoldtech/grid"
    }
  }
}
provider "grid" {
}

locals {
  name = "myvm"
}

resource "grid_network" "net1" {
  name = "network"  
  nodes       = [2098]
  ip_range    = "10.1.0.0/16"
  description = "newer network"
  # add_wg_access = true
}
resource "grid_deployment" "d1" {
  node         = 2098
  network_name = grid_network.net1.name
  ip_range     = lookup(grid_network.net1.nodes_ip_range, 2098, "")
  disks {
    name        = "store"
    size        = 50
    description = "volume holding store data"
  }

  vms {
    name  = "nixos1"
    flist = "https://hub.grid.tf/tf-official-vms/nixos-micro-latest.flist"
    cpu   = 2
    # publicip   = true
    memory     = 2048
    entrypoint = "/entrypoint.sh"
    mounts {
      disk_name   = "store"
      mount_point = "/nix"
    }

    env_vars = {
      SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/9RNGKRjHvViunSOXhBF7EumrWvmqAAVJSrfGdLaVasgaYK6tkTRDzpZNplh3Tk1aowneXnZffygzIIZ82FWQYBo04IBWwFDOsCawjVbuAfcd9ZslYEYB3QnxV6ogQ4rvXnJ7IHgm3E3SZvt2l45WIyFn6ZKuFifK1aXhZkxHIPf31q68R2idJ764EsfqXfaf3q8H3u4G0NjfWmdPm9nwf/RJDZO+KYFLQ9wXeqRn6u/mRx+u7UD+Uo0xgjRQk1m8V+KuLAmqAosFdlAq0pBO8lEBpSebYdvRWxpM0QSdNrYQcMLVRX7IehizyTt+5sYYbp6f11WWcxLx0QDsUZ/J"

      NIX_CONFIG = <<EOT
{ pkgs ? import <nixpkgs> { }, pythonPackages ? pkgs.python3Packages }:

pkgs.mkShell {
  buildInputs = [
     pythonPackages.numpy
     pythonPackages.scipy
     pythonPackages.jupyterlab
  ];

}
EOT
    }

    planetary = true
  }
}

output "wg_config" {
  value = grid_network.net1.access_wg_config
}
output "node1_zmachine1_ip" {
  value = grid_deployment.d1.vms[0].ip
}
output "public_ip" {
  value = grid_deployment.d1.vms[0].computedip
}

output "ygg_ip" {
  value = grid_deployment.d1.vms[0].ygg_ip
}