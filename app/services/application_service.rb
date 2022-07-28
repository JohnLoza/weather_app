# fronzen_string_literal: true

class ApplicationService
  include StandardResponse

  def self.call(*args)
    self.new(*args).call
  end
end
