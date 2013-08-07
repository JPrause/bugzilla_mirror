class BzQueryOutput < ActiveRecord::Base
  before_create :bz_query_output_create
  belongs_to :bz_query
  attr_accessible :output, :product, :flag, :bug_status, :bz_id, :version
  serialize :product
  serialize :flag
  serialize :bug_status
  serialize :bz_id
  serialize :version

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
  def bz_query_output_create
    logger.info "Called before_create"
    self.product = get_token_values(self.output, "PRODUCT")
    self.flag = get_token_values(self.output, "FLAG")
    self.bug_status = get_token_values(self.output, "BUG_STATUS")
    self.bz_id = get_token_values(self.output, "ID")
    self.version = get_token_values(self.output, "VERSION")
  end

end
