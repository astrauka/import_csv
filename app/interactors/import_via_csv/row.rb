module ImportViaCsv
  class Row
    attr_reader :row, :build_strategy, :failure

    def initialize(row, build_strategy = nil)
      @row = row
      @build_strategy = build_strategy
    end

    def run
      # record failure when object is not valid
      record_failure unless persist

      self
    end

    def build_object_from_attributes
      if build_strategy && build_strategy.respond_to?("build")
        build_strategy.build object_attributes.with_indifferent_access
      else
        raise "Please define strategy for building object from attributes"
      end
    end

    def object_attributes
      @object_attributes ||= begin
        row.to_hash.symbolize_keys.select do |key, value|
          key.is_a? Symbol # reject everything that was not converted to symbol
        end
      end
    end

    def object
      @object ||= build_object_from_attributes
    end

    def object_is_valid?
      # the order is important as we add object base error manually
      object.errors.empty? && object.valid?
    end

    def persist
      object_is_valid? && object.save
    end

    def record_failure
      @failure = [object, object_attributes]
    end
  end
end
