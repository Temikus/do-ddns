deploy_dir = "/usr/lib/ddns/"
router_address = "10.0.0.1"

desc "Install the script"
task :deploy => [:copy_script]

desc "Install the ddns script"
task :copy_script do
  system("scp update_do.sh root@#{router_address}:#{deploy_dir}")
end
