require 'fbtft-build/fbtft-kernel'

release :fbtft_master => :fbtft_kernel_common do
  ENV['FBTFT_KERNEL_CONFIG'] = 'm'
end


# this first action executes before invoking prerequisites
release :fbtft_builtin => :fbtft_kernel_common do
  ENV['FBTFT_KERNEL_CONFIG'] = 'y'
end
# this action executes as normally after invoking prerequisites
release :fbtft_builtin do
  config 'SPI_BCM2708', :enable
  config 'BCM2708_SPIDEV', :disable
end


release :fbtft_latest => :fbtft_kernel_common do
  ENV['FBTFT_KERNEL_CONFIG'] = 'm'
  VAR['RASPBERRYPI_LINUX_BRANCH'] = raspberrypi_linux_latest
  info "RASPBERRYPI_LINUX_BRANCH = #{ENV['RASPBERRYPI_LINUX_BRANCH']}"
  VAR['FW_BRANCH'] = 'latest'
end
