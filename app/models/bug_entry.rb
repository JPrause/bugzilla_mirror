class BugEntry
  attr_accessor :bz_id, :dep_ids, :pm_acks, :devel_acks, :qa_acks, :doc_acks, :ver_acks, :version, :summary

  def initialize(bz) 
    @bz_id      = bz.bz_id
    @dep_ids    = bz.dep_id == "[]" ? "[]" :  bz.dep_id.to_s.split(",")                
    @pm_acks    = bz.pm_ack == "+" ? "X" : " "
    @devel_acks = bz.devel_ack == "+" ? "X" : " "
    @qa_acks    = bz.qa_ack == "+" ? "X" : " "
    @doc_acks   = bz.doc_ack == "+" ? "X" : " "
    @ver_acks   = bz.version_ack == "+" ? "X" : " "
    @version    = bz.version
    @summary    = bz.summary
  end

end
