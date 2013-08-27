class ErrataReport < ActiveRecord::Base

  include QueryMixin

  attr_accessible :name, :description, :version,
    :query_id, :query_name, :query_occurrence,
    :email_addr_devel_ack, :email_addr_pm_ack, :email_addr_qa_ack,
    :send_email_devel_ack, :send_email_pm_ack, :send_email_qa_ack

  def run

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

    bz_query_out = get_query_output(self)

    bz_query_out

  end

end
