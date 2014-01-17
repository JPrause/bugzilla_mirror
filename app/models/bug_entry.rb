class BugEntry
  attr_accessor :attributes
  def initialize(attributes) 
    @attributes=attributes
  end

  def [](key)
    @attributes[key]
  end

  def bz_id
    self[:BZ_ID]
  end

  def dep_ids
    if self[:DEP_ID] == "[]"
      [""]
    else
      self[:DEP_ID].to_s.split(",")                
    end
  end

end
