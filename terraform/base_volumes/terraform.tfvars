pools_path_root = "/wrk/kvm/pools"
pool_base       = "bases"
bases = {
  ubuntu-focal = {
    url  = "https://cloud-images.ubuntu.com/focal/20221121/focal-server-cloudimg-amd64-disk-kvm.img"
    name = "ubuntu-focal.qcow2"
  }
  ubuntu-jammy = {
    url  = "https://cloud-images.ubuntu.com/jammy/20221120/jammy-server-cloudimg-amd64-disk-kvm.img"
    name = "ubuntu-jammy.qcow2"
  }
  ubuntu-bionic = {
    url  = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
    name = "ubuntu-bionic.qcow2"
  }
  centos-7 = {
    url  = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2"
    name = "centos-7.qcow2"
  }
  centos-8-stream = {
    url  = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2"
    name = "centos-8-stream.qcow2"
  }
  centos-9-stream = {
    url  = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220829.0.x86_64.qcow2"
    name = "centos-9-stream.qcow2"
  }
}