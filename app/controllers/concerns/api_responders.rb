module ApiResponders
  extend ActiveSupport::Concern

  private

  def respond_with_error(message, status: :unprocessable_entity, context: {})
    is_exception = message.is_a?(StandardError)
    error_message = is_exception ? message.record&.errors_to_sentence : message
    render status: status, json: { error: error_message }.merge(context)
  end

  def respond_with_success(message, status: :ok, context: {})
    render status: status, json: { message: message }.merge(context)
  end

  def respond_with_json(json = {}, status: :ok)
    render status: status, json: json
  end
end
