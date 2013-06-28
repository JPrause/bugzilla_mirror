class Query < ActiveRecord::Base
  attr_accessible :bug_status, :description, :flag, :name, :outputformat, :product
end
