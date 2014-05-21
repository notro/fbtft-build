package :fbtft_tools do
  git 'https://github.com/notro/fbtft_tools', 'fbtft_tools'
end

package :mouse_gpio => :fbtft_tools do
  config 'INPUT_MOUSE', :enable, 'n'
  config 'MOUSE_GPIO', :module

  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/gpio_mouse_device'} modules modules_install"
  end
end


package :keyboard_gpio => :fbtft_tools do
  config 'INPUT_KEYBOARD', :enable, 'n'
  config 'KEYBOARD_GPIO', :module

  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/gpio_keys_device'} modules modules_install"
  end
end


package :ads7846 => :fbtft_tools do
  config 'INPUT_TOUCHSCREEN', :enable, 'n'
  config 'TOUCHSCREEN_ADS7846', :module

  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/ads7846_device'} modules modules_install"
  end
end


package :rpi_power_switch => :fbtft_tools do
  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/rpi_power_switch'} modules modules_install"
  end
end


package :gpio_backlight => :fbtft_tools do
  ENV['GPIO_BACKLIGHT_CONFIG'] ||= 'module'
  config 'BACKLIGHT_GPIO', ENV['GPIO_BACKLIGHT_CONFIG']

  # backported to 3.10
  patch 'gpio_backlight.patch'

  # maybe this is in by 3.15?
  # backlight: gpio-backlight: Fix warning when the GPIO is on a I2C chip
  #   2014-05-19 15:50 => Applied, thanks.
  patch 'gpio_backlight-gpio-can-sleep.patch'

  task :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/gpio_backlight_device'} modules modules_install"
  end
end
