require 'csv'

module CSVModule

  def generate_data(location, type)
    array = []
    CSV.foreach(location, headers: true) do |row|
      array << type.new(row.to_hash)
    end
    array
  end
end
