namespace :bugzilla do
  namespace :db do
    desc "Periodically Refresh the Database from the Updated Issues in Bugzilla"
    task :update_loop => :environment do
      loop do
        WorkerManager.update_database_from_bugzilla
        update_interval = WorkerManager.options["update_interval"]
        Rails.logger.info "Sleeping #{update_interval / 60} minutes until next update ..."
        sleep(update_interval)
      end
    end

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
