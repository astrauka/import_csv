class ImportUtil

  # begin
  #   financial.currency = Currency.find_by!(code: attributes[:currency])
  # rescue ActiveRecord::RecordNotFound => e
  #   financial.errors.add(:base, "Currency was not found - #{attributes[:currency]}")
  #   raise e
  # end
  def self.assign_belongs_to_relation(assignee, assignee_attribute, relation_klass, relation_finder_attributes)
    begin
      assignee.public_send("#{assignee_attribute}=",
                            relation_klass.find_by!(relation_finder_attributes))
    rescue ActiveRecord::RecordNotFound => e
      assignee.errors.add(:base, "#{relation_klass} was not found - #{formatted_attributes relation_finder_attributes}")
      raise e
    end
  end

  def self.formatted_attributes(attributes)
    attributes.map do |key, value|
      "#{key}: #{value}"
    end.join("; ")
  end
end
