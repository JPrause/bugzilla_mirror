class Comment < ActiveRecord::Base
  belongs_to :issue

  ATTRIBUTES = [
    :count,
    :text,
    :created_by,
    :created_on,
    :private
  ]

  attr_accessible(*ATTRIBUTES)
end
