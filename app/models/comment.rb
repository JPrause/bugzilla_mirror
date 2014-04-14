class Comment < ActiveRecord::Base
  belongs_to :issue

  ATTRIBUTES = [
    :count,
    :text,
    :created_by,
    :created_on,
    :private
  ]

  def presentable_hash
    attributes.slice(*ATTRIBUTES.collect(&:to_s))
  end

  # Can be called with either this Comment object or ActiveBugzilla::Comment
  def self.object_to_presentable_hash(obj)
    hash = obj.respond_to?(:attributes) ? obj.attributes : obj.instance_values
    hash.slice(*ATTRIBUTES.collect(&:to_s))
  end
end
