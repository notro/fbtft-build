require 'fbtft-build/fbtft-kernel'

release :fbtft_master => :fbtft_kernel_common do
  ENV['LINUX_DEFCONFIG'] = 'bcmrpi_defconfig'
  ENV['FBTFT_KERNEL_CONFIG'] = 'm'

  config("DYNAMIC_DEBUG", :enable)
end


# this first action executes before invoking prerequisites
release :fbtft_builtin => :fbtft_kernel_common do
  ENV['LINUX_DEFCONFIG'] = 'bcmrpi_defconfig'
  ENV['FBTFT_KERNEL_CONFIG'] = 'y'

  config("DYNAMIC_DEBUG", :enable)
end
# this action executes as normally after invoking prerequisites
release :fbtft_builtin do
  config 'SPI_BCM2708', :enable
  config 'BCM2708_SPIDEV', :disable
end


release :fbtft_next => :fbtft_kernel_common do
  ENV['LINUX_DEFCONFIG'] = 'bcmrpi_defconfig'
  ENV['FBTFT_KERNEL_CONFIG'] = 'm'

  config("DYNAMIC_DEBUG", :enable)
end
release :fbtft_next do
end
