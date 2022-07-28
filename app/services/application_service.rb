# fronzen_string_literal: true

class ApplicationService
  def self.call(*args)
    self.new(*args).call
  end

  private

  def success_response(data, message = nil)
    {
      success?: true,
      message: message || 'successful operation',
      data: data,
      error: nil
    }
  end

  def error_response(error, message = nil)
    {
      success?: false,
      message: message || 'invalid operation',
      data: nil,
      error: error
    }
  end
end
