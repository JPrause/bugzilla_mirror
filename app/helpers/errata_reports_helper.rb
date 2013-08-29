module ErrataReportsHelper

  def title(key)
    key.to_s.tr("_", " ").titleize
  end

end
