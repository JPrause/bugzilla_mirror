class BugEntry
  attr_accessor :bz_id, :dep_ids, :pm_acks, :devel_acks, :qa_acks, :doc_acks, :ver_acks, :flag_version, :summary

  def initialize(bz) 
    @bz_id        = bz.bz_id
    @dep_ids      = bz.dep_id == "[]" ? "" :  bz.dep_id.to_s.split(",")                
    @pm_acks      = display_for_ack(bz.pm_ack)
    @devel_acks   = display_for_ack(bz.devel_ack)
    @qa_acks      = display_for_ack(bz.qa_ack)
    @doc_acks     = display_for_ack(bz.doc_ack)
    @ver_acks     = display_for_ack(bz.version_ack)
    @flag_version = bz.flag_version
    @summary      = bz.summary
  end

  def has_all_acks?
      a = [pm_acks, devel_acks, qa_acks, doc_acks, ver_acks]
      (a & a).size == 1
  end

  private
  def display_for_ack(ack)
    ack == "+" ? "X" : " "
  end
    

end
