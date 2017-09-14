# == Class sysdig::install
#
class sysdig::install {

  case $::osfamily {
    'Debian': {

      include apt
      apt::source { 'sysdig':
        location          => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/ubuntu/',
        release           => 'sysdig-prod',
        repos             => 'main',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => '5D14BB9A4D883FC38BF3140C096343CA613ECD57',
        key_source        => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/gpg.key',
        include_src       => false,
      }

      ensure_packages(["linux-headers-${::kernelrelease}"])

      $dependencies = [
        Apt::Source['sysdig'],
        Package["linux-headers-${::kernelrelease}"],
      ]
    }
    'RedHat': {
      include 'epel'
      yumrepo { 'sysdig':
        baseurl  => 'http://download.draios.com/stable/rpm/$basearch',
        descr    => 'Sysdig repository by Draios',
        enabled  => 1,
        gpgcheck => 0,
      }

      ensure_packages(["kernel-devel-${::kernelrelease}"])

      $dependencies = [ Yumrepo['sysdig'], Class['epel'] ]
    }
    default: {
      $dependencies = []
    }
  }

  package { 'sysdig':
    ensure  => $sysdig::ensure,
    require => $dependencies,
  }
}
