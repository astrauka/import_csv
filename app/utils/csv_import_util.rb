class CsvImportUtil
  # begin
  #   financial.currency = Currency.find_by!(code: attributes[:currency])
  # rescue ActiveRecord::RecordNotFound => e
  #   financial.errors.add(:base, "Currency was not found - #{attributes[:currency]}")
  #   raise e
  # end
  def self.assign_belongs_to_relation(object, attribute, relation_klass, relation_finder_attributes)
    begin
      object.public_send "#{attribute}=", relation_klass.find_by!(relation_finder_attributes)
    rescue ActiveRecord::RecordNotFound => e
      object.errors.add(:base, "#{relation_klass} was not found - #{formatted_attributes relation_finder_attributes}")
      raise e
    end
  end

  def self.formatted_attributes(attributes)
    attributes.map do |key, value|
      "#{key}: #{value}"
    end.join("; ")
  end
end
