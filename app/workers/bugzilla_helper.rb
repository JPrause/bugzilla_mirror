module BugzillaHelper
  include ApplicationHelper

  def spawn_issue_processes(bug_ids, klass)
    total_count = bug_ids.count
    logger.info "#{klass}: #{total_count} issues to process ..."
    return unless total_count
    max_clients = bz_options["max_clients"] || 10
    chunk_size  = bz_options["issues_per_client"] || 100
    chunks      = bug_ids.each_slice(chunk_size).to_a
    logger.info "#{klass}: Queuing Issue refreshes per chunk size of #{chunk_size} issues each ..."
    logger.info "#{klass}: Spawing up to #{max_clients} processes ..."
    init_time   = Time.now.tv_sec
    Parallel.map(chunks, :in_processes => max_clients) do |bug_id_list|
      time1      = Time.now.tv_sec
      num_failed = klass.new.perform(bug_id_list)
      nsecs      = Time.now.tv_sec - time1
      logger.info "#{klass}: Took #{nsecs} seconds for #{bug_id_list.count} issues"
      logger.info "#{klass}: #{num_failed} Issues failed" if num_failed > 0
    end
    spanned_time = Time.now.tv_sec - init_time
    logger.info "#{klass}: Took #{spanned_time} seconds for #{total_count} issues"
  end
end
