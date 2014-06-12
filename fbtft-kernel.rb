require 'stdlib/rpi-linux'
require 'fbtft-build/fbtft'
require 'fbtft-build/fbtft_tools'

# DMA capable SPI master driver
package :spi_bcm2708_dma do
  github_tarball 'notro/spi-bcm2708', 'spi-bcm2708-dma'

  target :patch do
    cp workdir('spi-bcm2708-dma/spi-bcm2708.c'), workdir('linux/drivers/spi')
  end
end


package :spi_config do
  github_tarball 'msperl/spi-config', 'spi-config'

  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'spi-config'} modules modules_install"
  end
end


package :pitft => [:fbtft_tools, :gpio_backlight] do
  config 'INPUT_TOUCHSCREEN', :enable, 'n'
  config 'MFD_STMPE', :enable, ''
  config ['STMPE_SPI', 'GPIO_STMPE'], :enable
  config 'TOUCHSCREEN_STMPE', :module

  patch 'stmpe-ts-Various-fixes.patch'

  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/stmpe_device'} modules modules_install"
  end
end


package :fbtft_kernel_common => [:rpi_linux_common, :spi_bcm2708_dma, :fbtft,
                                 :spi_config, :pitft, :ads7846, :keyboard_gpio, :mouse_gpio] do
  ENV['FBTFT_KERNEL_CONFIG'] ||= 'm'

  config "DYNAMIC_DEBUG", :enable

  # All console fonts as builtins and rotation
  config ["FONTS", "FRAMEBUFFER_CONSOLE_ROTATION"], :enable, 'y'

  # Bitbanged SPI bus
  config 'CONFIG_SPI_GPIO', :module
  
  # MCP23S08/MCP23S17/MCP23008/MCP23017
  config 'CONFIG_GPIO_MCP23S08', :module

  # CAN
  config 'CONFIG_CAN', :enable
  config ['CONFIG_CAN_RAW',    # Raw CAN Protocol (raw access with CAN-ID filtering)
          'CONFIG_CAN_BCM',    # Broadcast Manager CAN Protocol (with content filtering)
          'CONFIG_CAN_VCAN',   # Virtual Local CAN Interface (vcan) - CAN loopback
          'CONFIG_CAN_SLCAN',  # Serial / USB serial CAN Adaptors (slcan)
          'CONFIG_CAN_MCP251X' # Microchip MCP251x SPI CAN controllers
          ], :module

  # for 3.10
  patch 'mach-bcm2708-Reserve-64-IRQs-for-peripherals.patch'
  patch 'make-room-for-gpio-chips.patch'

end
