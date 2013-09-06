class BzQueryOutput < ActiveRecord::Base
  before_create :bz_query_output_create
  after_commit :bz_query_entry_create
  belongs_to :bz_query

  has_many :bz_query_entries, :dependent => :destroy
  attr_accessible :output, :product, :flag, :bug_status, :bz_id, :version

  serialize :product
  serialize :flag
  serialize :bug_status
  serialize :bz_id
  serialize :version

  VERSION_REGEX=/cfme-[0-9]\.?[0-9]?\.?z?/

  private
  def get_from_flags(str, regex)
    flags = get_token_values(str, "FLAGS").join
    match = regex.match(flags)

    if match
      return [match[0], match.post_match[0]]
    else
      return ["NONE", "NONE"]
    end
   
  end

  # TODO Update all tokens to have token_END delimiter.
  private
  def get_token_values(str, token)
    token_values = str.scan(/(?<=#{token}:\s).*(?<=#{token}_END)/)
    token_values = str.scan(/(?<=#{token}:\s)\S*/) unless token_values != []

    # Because regexp lookahead and lookbehind must be a fixed length
    # removing the occasionally occuring trailing ->'<- character must
    # be done in a separate step.
    token_values.each do |x|
      x.sub!("#{token}_END", "")
      x.sub!(/'$/, '')
    end

    token_values
  end

  private
  def bz_query_output_create
    logger.info "Called before_create bz_query_output_create"
    self.product = get_token_values(self.output, "PRODUCT")
    self.flag = get_token_values(self.output, "FLAGS")
    self.bug_status = get_token_values(self.output, "BUG_STATUS")
    self.bz_id = get_token_values(self.output, "ID")
    self.version = get_token_values(self.output, "VERSION")
  end

  private
  def bz_query_entry_create
    logger.info "Called after_create bz_query_entry_create"

    # create a new bz_query_entries object in the db for each bz.
    self.output.each_line do |bz_line|
      # create a new bz_query_entries object in the db for each
      # BZ (line) in the output.
      bz_id = get_token_values(bz_line, "BZ_ID").join
      summary = get_token_values(bz_line, "SUMMARY").join
      status = get_token_values(bz_line, "BUG_STATUS").join

      pm_ack_str, pm_ack = get_from_flags(bz_line, /pm_ack/)
      devel_ack_str, devel_ack = get_from_flags(bz_line, /devel_ack/)
      qa_ack_str, qa_ack = get_from_flags(bz_line, /qa_ack/)
      doc_ack_str, doc_ack = get_from_flags(bz_line, /doc_ack/)
      version_str, version_ack = get_from_flags(bz_line, VERSION_REGEX)

      bz_query_entries.create(:bz_id         => bz_id,
                              :pm_ack        => pm_ack,
                              :devel_ack     => devel_ack,
                              :qa_ack        => qa_ack,
                              :doc_ack       => doc_ack,
                              :summary       => summary,
                              :status        => status,
                              :version       => version_str,
                              :version_ack   => version_ack)
    end
    
  end

end
