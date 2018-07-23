module Support
  # = API Spec helpers
  module APIHelper
    def response_json
      @response_json ||= JSON.parse(response.body)
    end
  end
end
