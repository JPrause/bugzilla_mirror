class BzQueryEntry < ActiveRecord::Base
  before_create :bz_query_entry_create
  belongs_to :bz_query_output
  attr_accessible :bz_id, :pm_ack, :devel_ack, :qa_ack, :doc_ack, :status

  private
  def get_token_values(str, token)
    token_values = str.scan(/(?<=#{token}:\s)\S*/)

    # Because regexp lookahead and lookbehind must be a fixed length
    # removing the occasionally occuring trailing ->'<- character must
    # be done in a separate step.
    token_values.each do |x|
      x.sub!(/'$/, '')
    end

    token_values
  end

  private
  def bz_query_entry_create(line)

    logger.info "Called before_create bz_query_entry_create(->#{line}<-)"

    self.bz_id = get_token_values(line, "BZ_ID")
    self.pm_ack = get_token_values(line, "FLAGS")
    self.devel_ack = get_token_values(line, "FLAGS")
    self.qa_ack = get_token_values(line, "FLAGS")
    self.doc_ack = get_token_values(line, "FLAGS")
    self.status = get_token_values(line, "BUG_STATUS")
  end

end
