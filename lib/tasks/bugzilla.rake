namespace :bugzilla do
  def do_refresh
    Dir.chdir("/root/cfme_bz/cfme") do
      `git fetch --all`
    end

    Issue.update_from_bz
    Commit.update_from_git!
  end

  desc "Run loop for the bugzilla refresh"
  task :refresh_loop => :environment do
    loop do
      do_refresh
      sleep(60)
    end
  end

  task :refresh => :environment do
    do_refresh
  end
end
