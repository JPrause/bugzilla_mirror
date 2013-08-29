class ErrataReport < ActiveRecord::Base

  include QueryMixin

  attr_accessible :name, :description, :version,
    :query_id, :query_name, :query_occurrence,
    :email_addr_devel_ack, :email_addr_pm_ack, :email_addr_qa_ack,
    :send_email_devel_ack, :send_email_pm_ack, :send_email_qa_ack

  def run

    @needs_pm_ack = []
    @needs_devel_ack = []
    @needs_qa_ack = []
    @needs_doc_ack = []
    @needs_version_ack = []

    @needs_acks = { :needs_pm_ack       => @needs_pm_ack,
                    :needs_devel_ack    => @needs_devel_ack,
                    :needs_qa_ack       => @needs_qa_ack,
                    :needs_doc_ack      => @needs_doc_ack,
                    :needs_version_ack  => @needs_version_ack }



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
      @needs_version_ack << bz.bz_id unless ack_not_needed? bz.version_ack
      @needs_pm_ack << bz.bz_id unless ack_not_needed? bz.pm_ack
      @needs_devel_ack << bz.bz_id unless ack_not_needed? bz.devel_ack
      @needs_qa_ack << bz.bz_id unless ack_not_needed? bz.qa_ack
      @needs_doc_ack << bz.bz_id unless ack_not_needed? bz.doc_ack
      
    end

    @needs_acks

  end

  private
  def ack_not_needed?(ack)
    ack == "+" || ack.upcase == "NONE"
  end

end
