class ErrataReportsController < ApplicationController

  # GET /errata_reports
  # GET /errata_reports.json
  def index

    @need_acks = []
    @have_acks = []

    # TODO: When where.not method becomes available in Rails 4 this
    #       logic could possibly be simplified.
    Issue.where(:status => "POST").order(:id).each do |bz|

      entry = {:BZ_ID      => bz.bz_id,
               :PM_ACKS    => bz.pm_ack == "+" ? "X" : " ",
               :DEVEL_ACKS => bz.devel_ack == "+" ? "X" : " ",
               :QA_ACKS    => bz.qa_ack == "+" ? "X" : " ",
               :DOC_ACKS   => bz.doc_ack == "+" ? "X" : " ",
               :VER_ACKS   => bz.version_ack == "+" ? "X" : " ",
               :VERSION    => bz.version,
               :SUMMARY    => bz.summary}

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
end
