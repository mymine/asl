container_zip() {
  local os=$1
  local version=$2

  sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${os}\"/g" config.conf
  sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${version}\"/g" config.conf

  zip -r "../asl-${os}-${version}.zip" . -x "*.git/*" -x ".github/*" -x "build/*"
  
  echo "asl-${os}-${version}.zip"
}

container_zip "archlinux" "current"
container_zip "alpine" "edge"
container_zip "centos" "9-Stream"
container_zip "debian" "bookworm"
container_zip "ubuntu" "jammy"
container_zip "ubuntu" "oracular"
