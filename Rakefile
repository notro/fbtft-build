require 'fbtft-build/fbtft-kernel'

release :fbtft_master => :fbtft_kernel_common do
  ENV['FBTFT_KERNEL_CONFIG'] = 'm'
end


# this first action executes before invoking prerequisites
release :fbtft_builtin => :fbtft_kernel_common do
  ENV['FBTFT_KERNEL_CONFIG'] = 'y'
  VAR['FW_BRANCH'] = 'builtin'
end
# this action executes as normally after invoking prerequisites
release :fbtft_builtin do
  config 'SPI_BCM2708', :enable
  config 'BCM2708_SPIDEV', :disable
end


package :rpi_dts do
  patch 'disable-spidev-dts.patch'

  target :patch do
    if LinuxVersion.new(VAR['LINUX_KERNEL_VERSION']) >= LinuxVersion.new('3.15')
      src = workdir('linux/drivers/video/fbdev/fbtft/dts/rpi.dts')
    else
      src = workdir('linux/drivers/video/fbtft/dts/rpi.dts')
    end
    sh "cat #{src} >> #{workdir('linux/arch/arm/boot/dts/bcm2708-rpi-b.dts')}"
  end

  target :kbuild do
      post_install <<EOM
dst=/usr/local/src/fbtft_dts
echo "     DT source files in: ${dst}"
cp -R "${FW_REPOLOCAL}/extra/dts" ${dst}

EOM
  end

  target :build do
    dst = workdir 'out/extra/dts'
    sh "mkdir -p #{dst}"
    sh "cd #{workdir 'linux/arch/arm/boot/dts'} && cp skeleton.dtsi bcm2708.dtsi bcm2708-rpi-b.dts #{dst}"
  end
end

release :fbtft_latest => [:fbtft_kernel_common, :vcboot_dt, :rpi_dts] do
  ENV['FBTFT_KERNEL_CONFIG'] = 'm'
  VAR['RASPBERRYPI_LINUX_BRANCH'] = raspberrypi_linux_latest
  info "RASPBERRYPI_LINUX_BRANCH = #{ENV['RASPBERRYPI_LINUX_BRANCH']}"
  config ['BCM2708_DT', 'DYNAMIC_DEBUG', 'PROC_DEVICETREE'], :enable
  config ['SPI_BCM2835', 'I2C_BCM2835'], :module
  VAR['FW_BRANCH'] = 'latest'
end
