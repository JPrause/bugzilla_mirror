class ErrataReport < ActiveRecord::Base
  attr_accessible :description, :email_addr_devel_ack, :email_addr_pm_ack, :email_addr_qa_ack, :name, :query_id, :query_name, :query_occurance, :send_email_devel_ack, :send_email_pm_ack, :send_email_qa_ack, :version
end
