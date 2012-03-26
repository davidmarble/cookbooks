packages = value_for_platform(
    ["centos","redhat","fedora"] => {'default' => ['ghostscript']},
    "default" => ['ghostscript']
  )

packages.each do |devpkg|
  package devpkg
end

