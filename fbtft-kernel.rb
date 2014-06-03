require 'stdlib/base'
require 'stdlib/rpi-linux'
require 'fbtft-build/fbtft'
require 'fbtft-build/fbtft_tools'

# DMA capable SPI master driver
package :spi_bcm2708_dma do
  github_tarball 'notro/spi-bcm2708', 'spi-bcm2708-dma'

  task :patch do
    cp workdir('spi-bcm2708-dma/spi-bcm2708.c'), workdir('linux/drivers/spi')
  end
end


package :spi_config do
  github_tarball 'msperl/spi-config', 'spi-config'

  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'spi-config'} modules modules_install"
  end
end


package :fdt_loader do
  github_tarball 'notro/fdt_loader', 'fdt_loader'

  task :patch do
		cp workdir('fdt_loader/fdt_loader.c'), workdir('linux/drivers/misc/')
    cp workdir('fdt_loader/pinctrl-bcm2708.c'), workdir('linux/arch/arm/mach-bcm2708/')
  end

  config ['USE_OF', 'FDT_LOADER', 'PINCTRL_BCM2708'], :enable
  config 'PROC_DEVICETREE', :enable
  config 'BCM2708_SPIDEV', :disable # Get's in the way of SPI devices in Devicetree

  patch 'fdt_loader.patch'
  patch 'pinctrl-bcm2708.patch'

  target :kbuild do
    dst = workdir 'modules/lib/firmware'
    mkdir_p dst unless File.exists? dst
    cp FileList['dts/*'], dst
    FileList["#{dst}/*.dts"].each do |dts|
      dtb = File.basename(dts, File.extname(dts)) + '.dtb'
      sh "cd #{File.dirname dts} && #{workdir 'linux/scripts/dtc/dtc'} -O dtb -o #{dtb} -I dts #{dts}"
    end
  end

end


package :pitft => [:fbtft_tools, :gpio_backlight] do
  config 'INPUT_TOUCHSCREEN', :enable, 'n'
  config 'MFD_STMPE', :enable, ''
  config ['STMPE_SPI', 'GPIO_STMPE'], :enable
  config 'TOUCHSCREEN_STMPE', :module

  patch 'stmpe-ts-Various-fixes.patch'

  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/stmpe_device'} modules modules_install"
  end
end


package :fbtft_kernel_common => [:issue106, :rpi_tools, :rpi_firmware, :rpi_linux, :spi_bcm2708_dma, :fbtft, :spi_config, :fdt_loader, :pitft, :ads7846, :keyboard_gpio, :mouse_gpio] do
  ENV['FBTFT_KERNEL_CONFIG'] ||= 'm'

  config "DYNAMIC_DEBUG", :enable

  # All console fonts as builtins and rotation
  config ["FONTS", "FRAMEBUFFER_CONSOLE_ROTATION"], :enable, 'y'

  # "Bitbanged SPI bus"
  config 'CONFIG_SPI_GPIO', :module
  
  # "MCP23S08/MCP23S17/MCP23008/MCP23017"
  config 'CONFIG_GPIO_MCP23S08', :module

  # for 3.10
  patch 'mach-bcm2708-Reserve-64-IRQs-for-peripherals.patch'
  patch 'make-room-for-gpio-chips.patch'

end
