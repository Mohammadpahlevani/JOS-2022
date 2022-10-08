#source: https://gist.github.com/ecliptik/81ad7484d522097dca7f
#sudo apt-get install gdb
sudo apt-get install debootstrap qemu-utils qemu
sudo apt-get build-dep qemu
git clone https://github.com/geofft/qemu.git -b 6.828-1.7.0
cd qemu
./configure --disable-kvm --prefix=/home/qemu_installed --target-list="i386-softmmu x86_64-softmmu"
make 
make install 
