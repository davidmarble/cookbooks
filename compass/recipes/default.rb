script "Install Compass/Sass" do
    interpreter "bash"
    user "root"
    cwd "/tmp/"
    code <<-EOH
    gem update --system
    gem install compass rb-inotify --no-ri --no-rdoc
    EOH
    # not_if "which compass"
end
