# methods used in multiple places
module SharedCalculations
  def return_max(hash)
    hash.key(hash.values.max)
  end

  def return_min(hash)
    hash.key(hash.values.min)
  end
end
