package :fbtft do
  github_tarball "notro/fbtft", "fbtft"

  if ENV['FBTFT_KERNEL_CONFIG']
    config 'FB_TFT', ENV['FBTFT_KERNEL_CONFIG'], ENV['FBTFT_KERNEL_CONFIG']
  end

  patch 'fbtft.patch'
  d = file_create workdir 'linux/drivers/video/fbtft' do |t|
    ln_s workdir('fbtft'), t.name
  end
  task :patch => d.name
end
