class BzQuery < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name,
    :output_format, :product

  has_many :bz_query_outputs, :dependent => :destroy

  def run(bz_query)

    BzCommand.login!

    cmd, output = BzCommand.query(bz_query.product, bz_query.flag,
      bz_query.bug_status, bz_query.output_format)

    # create a new bz_query_outputs entry in the db and save this output there.
    bz_query_outputs.create(:output => output)
    
    output
  end
end
