module TestUnitExtensions
  def json_response
    @json_response_body ||= ActiveSupport::JSON.decode @response.body
  end

  def expect_json_response(actual_response, expected_response)
    if expected_response.is_a?(Array)
      expect actual_response.is_a?(Array) && (actual_response.length == expected_response.length)
    else
      expected_response.keys.each do |key|
        expect actual_response.has_key?(key)
        if expected_response[key].is_a?(Hash)
          expect_json_response(actual_response[key.to_s], expected_response[key])
        elsif expected_response[key].is_a?(Array)
          expect actual_response[key.to_s].is_a?(Array) && (actual_response[key.to_s].length == expected_response[key].length)
        elsif expected_response[key].present?
          expect(actual_response[key.to_s]).to be(expected_response[key])
        elsif actual_response[key].present?
          expect actual_response[key.to_s]
        end
      end
    end
  end

end
