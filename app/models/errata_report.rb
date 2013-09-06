class ErrataReport < ActiveRecord::Base

  include QueryMixin

  attr_accessible :name, :description, :version,
    :query_id, :query_name, :query_occurrence,
    :email_addr_devel_ack, :email_addr_pm_ack, :email_addr_qa_ack,
    :send_email_devel_ack, :send_email_pm_ack, :send_email_qa_ack

  def run

    @bzs_need_acks = []
    @bzs_have_acks = []

    logger.debug "name  ->#{self.name}<-"
    logger.debug "description  ->#{self.description}<-"                   
    logger.debug "version  ->#{self.version}<-"

    logger.debug "query_id  ->#{self.query_id}<-"                             
    logger.debug "query_name  ->#{self.query_name}<-"                         
    logger.debug "query_occurrence  ->#{self.query_occurrence}<-"             

    logger.debug "email_addr_devel_ack  ->#{self.email_addr_devel_ack}<-"
    logger.debug "email_addr_pm_ack  ->#{self.email_addr_pm_ack}<-"           
    logger.debug "email_addr_qa_ack  ->#{self.email_addr_qa_ack}<-"

    logger.debug "send_email_devel_ack  ->#{self.send_email_devel_ack}<-"     
    logger.debug "send_email_pm_ack  ->#{self.send_email_pm_ack}<-"
    logger.debug "send_email_qa_ack  ->#{self.send_email_qa_ack}<-"           

    get_query_entries(self).each do |bz|
      ack_code = ""

      ack_code << (ack_not_needed?(bz.pm_ack) ? "-" : "P")
      ack_code << (ack_not_needed?(bz.devel_ack) ? "-" : "D")
      ack_code << (ack_not_needed?(bz.qa_ack) ? "-" : "Q")
      ack_code << (ack_not_needed?(bz.doc_ack) ? "-" : "O")
      # The version ack is set by the Bugzilla Bot so user "B".
      ack_code << (ack_not_needed?(bz.version_ack) ? "-" : "B")
      bz_entry = {:BZ_ID   => bz.bz_id,
                  :ACKS    => ack_code,
                  :SUMMARY  => bz.summary}

      if ack_code == "-----"
        @bzs_have_acks << bz_entry
      else
        @bzs_need_acks << bz_entry
      end
    end

    [@bzs_need_acks, @bzs_have_acks]

  end

  private
  def ack_not_needed?(ack)
    ack == "+" || ack.upcase == "NONE"
  end

end
