OS="archlinux"
VERSION="current"
sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${OS}\"/g" config.conf
sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${VERSION}\"/g" config.conf
zip -r ../asl-$OS-$VERSION.zip .
echo asl-$OS-$VERSION.zip

OS="alpine"
VERSION="edge"
sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${OS}\"/g" config.conf
sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${VERSION}\"/g" config.conf
zip -r ../asl-$OS-$VERSION.zip .
echo asl-$OS-$VERSION.zip

OS="centos"
VERSION="9-Stream"
sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${OS}\"/g" config.conf
sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${VERSION}\"/g" config.conf
zip -r ../asl-$OS-$VERSION.zip .
echo asl-$OS-$VERSION.zip

OS="debian"
VERSION="bookworm"
sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${OS}\"/g" config.conf
sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${VERSION}\"/g" config.conf
zip -r ../asl-$OS-$VERSION.zip .
echo asl-$OS-$VERSION.zip

OS="ubuntu"
VERSION="jammy"
sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${OS}\"/g" config.conf
sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${VERSION}\"/g" config.conf
zip -r ../asl-$OS-$VERSION.zip .
echo asl-$OS-$VERSION.zip

OS="ubuntu"
VERSION="oracular"
sed -i "s/RURIMA_LXC_OS=\".*\"/RURIMA_LXC_OS=\"${OS}\"/g" config.conf
sed -i "s/RURIMA_LXC_OS_VERSION=\".*\"/RURIMA_LXC_OS_VERSION=\"${VERSION}\"/g" config.conf
zip -r ../asl-$OS-$VERSION.zip .
echo asl-$OS-$VERSION.zip