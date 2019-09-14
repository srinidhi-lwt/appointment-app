class CollectionSerializer
  def initialize(serializer, mapping)
    @serializer = serializer
    @mapping = mapping
  end

  def call
    mapping.map do |k, v|
      serializer.new(k, v).call
    end
  end

  attr_reader :serializer, :mapping
end