module ReportTablesHelper

  def get_bz_query_run_times(name)
    past_query_runs = [['NONE', 0]]
    puts "JJV "
    puts "JJV in get_bz_query_run_times"
    begin
      BzQuery.find_by_name(name).bz_query_outputs.each do |run|
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        puts "JJV updated_at: ->#{run.updated_at}<-"
        puts "JJV id: ->#{run.id}<-"
        past_query_runs << [run.updated_at, run.id]    
      end
    rescue
      past_query_runs = []
      past_query_runs = [['NONE', 0]]
    end

    past_query_runs
  end

end
