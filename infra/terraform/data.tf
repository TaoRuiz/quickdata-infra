#Modification de la config SSH du bastion
data "cloudinit_config" "bastion_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"

    content = yamlencode({
      users = [
        {
          name                = "bastion"
          shell               = "/bin/bash"
          ssh_authorized_keys = [file("~/.ssh/nocodb-keys/bastion-key.pub")]
        }
      ]

      write_files = [
        {
          path    = "/etc/ssh/sshd_config.d/custom_ssh.conf"
          content = file("${path.module}/data/bastion_custom_ssh.conf")
        },
        {
          path    = "/etc/sysctl.d/99-ip-forward.conf"
          content = "net.ipv4.ip_forward=1\n"
        }
      ]

      runcmd = [
        "systemctl restart ssh",

        # NAT
        "sysctl -w net.ipv4.ip_forward=1",
        "echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf",
        "apt-get install -y iptables-persistent",
        "iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE",
        "netfilter-persistent save"
      ]
    })
  }
}