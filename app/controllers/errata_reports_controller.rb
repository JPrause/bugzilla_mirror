class ErrataReportsController < ApplicationController

  # GET /errata_reports
  # GET /errata_reports.json
  def index

    puts "JJV -010- index params ->#{params}<-"
    puts "JJV -011- index params[\"version\"] ->#{params["version"]}<-"

    @need_acks = []
    @have_acks = []

    # TODO: When where.not method becomes available in Rails 4 this
    #       logic could possibly be simplified.
    Issue.where(:status => "POST").order(sort_column + " " + sort_direction).order(:version).each do |bz|
        entry = BugEntry.new(
          :BZ_ID      => bz.bz_id,
          :DEP_ID     => bz.dep_id,
          :PM_ACKS    => bz.pm_ack == "+" ? "X" : " ",
          :DEVEL_ACKS => bz.devel_ack == "+" ? "X" : " ",
          :QA_ACKS    => bz.qa_ack == "+" ? "X" : " ",
          :DOC_ACKS   => bz.doc_ack == "+" ? "X" : " ",
          :VER_ACKS   => bz.version_ack == "+" ? "X" : " ",
          :VERSION    => bz.version,
          :SUMMARY    => bz.summary)

        if has_all_acks?(entry)
          @have_acks << entry
        else
          @need_acks << entry
        end
    end

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end

  end

  private
  def has_all_acks?(entry)
      a = [entry[:PM_ACKS], entry[:DEVEL_ACKS], entry[:QA_ACKS], entry[:DOC_ACKS], entry[:VER_ACKS]]
      (a & a).size == 1
  end

  def display_version?(bz, requested_version)
    puts "JJV -070- display_version? requested_version ->#{requested_version}<-"
    
    if requested_version == "All" || requested_version == bz.version
      true
    else
      false
    end
  end

end
