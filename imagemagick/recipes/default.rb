include_recipe "ghostscript"

packages = value_for_platform(
    ["centos","redhat","fedora"] => {'default' => ['ImageMagick']},
    "default" => ['ImageMagick', 'libmagickwand-dev']
  )

packages.each do |devpkg|
  package devpkg
end
