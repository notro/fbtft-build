package :fbtft do
  github_tarball "notro/fbtft", "fbtft"

  if VAR['FBTFT_KERNEL_CONFIG']
    config 'FB_TFT', VAR['FBTFT_KERNEL_CONFIG'], VAR['FBTFT_KERNEL_CONFIG']
  end

  patch 'fbtft.patch'

  target :patch do
    if LinuxVersion.new(ENV['LINUX_KERNEL_VERSION']) >= LinuxVersion.new('3.15')
      ln_s workdir('fbtft'), workdir('linux/drivers/video/fbdev/fbtft')
    else
      ln_s workdir('fbtft'), workdir('linux/drivers/video/fbtft')
    end
  end
end
