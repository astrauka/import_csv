module ImportViaCsv
  class Companies
    def build_object_for_import(object_attributes)
      Company.new(object_attributes)
    end
  end
end
