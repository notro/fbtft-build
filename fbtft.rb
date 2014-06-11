package :fbtft do
  github_tarball "notro/fbtft", "fbtft"

  if VAR['FBTFT_KERNEL_CONFIG']
    config 'FB_TFT', VAR['FBTFT_KERNEL_CONFIG'], VAR['FBTFT_KERNEL_CONFIG']
  end

  patch 'fbtft.patch'
  d = file_create workdir 'linux/drivers/video/fbtft' do |t|
    ln_s workdir('fbtft'), t.name
  end
  target :patch => d.name
end
