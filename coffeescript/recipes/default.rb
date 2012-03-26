include_recipe "nodejs"

script "Install CoffeeScript" do
    interpreter "bash"
    user "root"
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    npm install -g coffee-script
    EOH
    # not_if "which coffee"
end
