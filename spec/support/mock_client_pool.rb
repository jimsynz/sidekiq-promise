class MockClientPool
  attr_accessor :mock_client

  def initialize mock_client
    self.mock_client = mock_client
  end

  def with
    yield mock_client
  end
end
