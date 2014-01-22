class ErrataReportsController < ApplicationController

  # GET /errata_reports
  # GET /errata_reports.json
  def index

    @need_acks = []
    @have_acks = []

    # TODO: When where.not method becomes available in Rails 4 this
    #       logic could possibly be simplified.
    Issue.where(:status => "POST").order(sort_column + " " + sort_direction).order(:flag_version).each do |bz|
      if display_flag_version?(bz, params["flag_version"])
        entry = BugEntry.new(bz)

        if entry.has_all_acks?
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
  def display_flag_version?(bz, requested_flag_version)
    requested_flag_version == "All" || requested_flag_version == bz.flag_version
  end

end
