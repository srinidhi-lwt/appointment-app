class BaseSerializer
  def initialize(key, value)
    @key = key
    @value = value
  end

  attr_reader :key, :value
end