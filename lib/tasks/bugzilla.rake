namespace :bugzilla do
  namespace :db do
    desc "One-time Refresh of the Database from the Updated Issues in Bugzilla"
    task :update => :environment do
      WorkerManager.update_database_from_bugzilla
    end

    desc "Reload the Database from Bugzilla using the Bulk Loader"
    task :reload => :environment do
      WorkerManager.reload_database_from_bugzilla
    end

    desc "Refresh the Issues Associations from Bugzilla"
    task :refresh_associations => :environment do
      WorkerManager.refresh_associations_from_bugzilla
    end
  end
end
