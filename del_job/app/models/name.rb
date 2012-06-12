class Name < ActiveRecord::Base
  def perform 
    name = find_by_first("Ajay")
    name.first = "Ajay Updated"
    name.save
  end
end
