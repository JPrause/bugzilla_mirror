class ErrataReport < ActiveRecord::Base

  def self.errata_report
    logger.debug "Invoked ErrataReport.self.errata_report"

    bzs_need_acks = []
    bzs_have_acks = []

    Issue.order(:id).each do |bz|
      ack_code = ""

      ack_code << (self.ack_not_needed?(bz.pm_ack) ? "-" : "P")
      ack_code << (self.ack_not_needed?(bz.devel_ack) ? "-" : "D")
      ack_code << (self.ack_not_needed?(bz.qa_ack) ? "-" : "Q")
      ack_code << (self.ack_not_needed?(bz.doc_ack) ? "-" : "O")
      # The version ack is set by the Bugzilla Bot so user "B".
      ack_code << (self.ack_not_needed?(bz.version_ack) ? "-" : "B")
      bz_entry = {:BZ_ID   => bz.bz_id,
                  :ACKS    => ack_code,
                  :SUMMARY  => bz.summary}

      if ack_code == "-----"
        bzs_have_acks << bz_entry
      else
        bzs_need_acks << bz_entry
      end
    end

    [bzs_need_acks, bzs_have_acks]

  end

  private
  def self.ack_not_needed?(ack)
    ack == "+" || ack.upcase == "NONE"
  end

end
