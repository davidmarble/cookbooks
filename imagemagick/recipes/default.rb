include_recipe "ghostscript"

packages = value_for_platform(
    ["centos","redhat","fedora"] => {'default' => ['ImageMagick', 'ImageMagick-devel']},
    ["ubuntu","debian"] => {"default" => ['imagemagick', 'libmagickwand-dev']},
    "default" => ['imagemagick']
  )

packages.each do |devpkg|
  package devpkg
end
