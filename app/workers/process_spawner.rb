require 'benchmark'

module ProcessSpawner
  include ApplicationMixin

  def spawn_issue_processes(bug_ids, klass)
    total_count = bug_ids.count
    logger.info "#{klass}: #{total_count} issues to process ..."
    return unless total_count
    max_clients = bz_options["max_clients"] || 10
    chunk_size  = bz_options["issues_per_client"] || 100
    chunks      = bug_ids.each_slice(chunk_size).to_a
    logger.info "#{klass}: Queuing Issue refreshes per chunk size of #{chunk_size} issues each ..."
    logger.info "#{klass}: Spawing up to #{max_clients} processes ..."

    time_taken = Benchmark.realtime do
      #
      # Note: current issues with OpenSSL. C-crashdump with working in multiple
      # sidekiq worker. We create seperate processes instead of threads (using parallel)
      # within the Sidekiq worker.
      #
      Parallel.map(chunks, :in_processes => max_clients) do |bug_id_list|
        num_failed = 0  # Must be initialized outside the Benchmark block.
        chunk_time_taken = Benchmark.realtime do
          num_failed = klass.new.perform(bug_id_list)
        end
        logger.info "#{klass}: Took #{chunk_time_taken} seconds for #{bug_id_list.count} issues"
        logger.info "#{klass}: #{num_failed} Issues failed" if num_failed > 0
      end
    end
    logger.info "#{klass}: Took #{time_taken} seconds for #{total_count} issues"
  end
end
