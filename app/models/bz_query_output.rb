class BzQueryOutput < ActiveRecord::Base
  belongs_to :bz_query
  attr_accessible :output
end
