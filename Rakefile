require 'fbtft-build/fbtft-kernel'

release :fbtft_master => :fbtft_kernel_common


# this first action executes before invoking prerequisites
release :fbtft_builtin => :fbtft_kernel_common do
  ENV['FBTFT_KERNEL_CONFIG'] = 'y'
end
# this action executes as normally after invoking prerequisites
release :fbtft_builtin do
  config 'SPI_BCM2708', :enable
  config 'BCM2708_SPIDEV', :disable
end


release :fbtft_next => :fbtft_kernel_common do
  TODO
end
release :fbtft_next do
end
