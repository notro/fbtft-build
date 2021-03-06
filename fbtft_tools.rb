package :fbtft_tools do
  github_tarball 'notro/fbtft_tools', 'fbtft_tools'
end

package :mouse_gpio => :fbtft_tools do
  config 'INPUT_MOUSE', :enable, 'n'
  config 'MOUSE_GPIO', :module

  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/gpio_mouse_device'} modules modules_install"
  end
end


package :keyboard_gpio => :fbtft_tools do
  config 'INPUT_KEYBOARD', :enable, 'n'
  config 'KEYBOARD_GPIO', :module

  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/gpio_keys_device'} modules modules_install"
  end
end


package :ads7846 => :fbtft_tools do
  config 'INPUT_TOUCHSCREEN', :enable, 'n'
  config 'TOUCHSCREEN_ADS7846', :module

  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/ads7846_device'} modules modules_install"
  end
end


package :rpi_power_switch => :fbtft_tools do
  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/rpi_power_switch'} modules modules_install"
  end
end


package :gpio_backlight => :fbtft_tools do
  VAR['GPIO_BACKLIGHT_CONFIG'] ||= 'module'
  config 'BACKLIGHT_GPIO', VAR['GPIO_BACKLIGHT_CONFIG']

  # backported to 3.10
  patch 'gpio_backlight.patch'

  # exists in 3.16
  patch 'gpio_backlight-gpio-can-sleep.patch'

  target :external do
    sh make "INSTALL_MOD_PATH=#{workdir 'modules'} M=#{workdir 'fbtft_tools/gpio_backlight_device'} modules modules_install"
  end
end
