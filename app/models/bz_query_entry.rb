class BzQueryEntry < ActiveRecord::Base
  before_create :bz_query_entry_create
  belongs_to :bz_query_output
  attr_accessible :bz_id, :pm_ack, :devel_ack, :qa_ack, :doc_ack, :status, :verion

  private
  def bz_query_entry_create

    logger.info "Called before_create bz_query_entry_create"

    puts ""
    puts "JJV -011- * * * * * * * * ** * * * * * * * ** * * * * * * * * "
    puts "JJV -011- bz_id     ->#{self.bz_id}<-"
    puts "JJV -011- pm_ack    ->#{self.pm_ack}<-"
    puts "JJV -011- devel_ack ->#{self.devel_ack}<-"
    puts "JJV -011- qa_ack    ->#{self.qa_ack}<-"
    puts "JJV -011- doc_ack   ->#{self.doc_ack}<-"
    puts "JJV -011- status    ->#{self.status}<-"
    puts "JJV -011- verion    ->#{self.verion}<-"
  end

end
