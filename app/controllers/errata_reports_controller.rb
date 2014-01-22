class ErrataReportsController < ApplicationController

  # GET /errata_reports
  # GET /errata_reports.json
  def index

    @need_acks = []
    @have_acks = []

    # TODO: When where.not method becomes available in Rails 4 this
    #       logic could possibly be simplified.
    Issue.where(:status => "POST").order(sort_column + " " + sort_direction).order(:version).each do |bz|
      if display_version?(bz, params["version"])
        entry = BugEntry.new(bz)

        if has_all_acks?(entry)
          @have_acks << entry
        else
          @need_acks << entry
        end
      end
    end

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end

  end

  private
  def has_all_acks?(entry)
      a = [entry.pm_acks, entry.devel_acks, entry.qa_acks, entry.doc_acks, entry.ver_acks]
      (a & a).size == 1
  end

  def display_version?(bz, requested_version)
    requested_version == "All" || requested_version == bz.version
  end

end
