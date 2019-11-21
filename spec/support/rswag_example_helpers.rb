# frozen_string_literal: true

module RswagExampleHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def save_rswag_examples!
      after(:each) do |example|
        if response.body.length > 1
          example.metadata[:response][:examples] = {
            'application/json' => JSON.parse(response.body, symbolize_names: true)
          }
        end

        # Can only record one example for requests, so only save successful examples
        next unless example.metadata[:response][:code].to_s.match?(/^2/)
        next unless example.metadata[:operation][:parameters]
        example.metadata[:operation][:parameters].each do |parameter|
          # Some parameters are optional and are not defined for all tests
          next unless respond_to?(parameter[:name])
          value = send(parameter[:name])
          case parameter[:in]
          when :body
            if parameter[:schema] && parameter[:schema]['$ref']
              ref_name = parameter[:schema]['$ref']
                .sub(/^#\/definitions\//, '').to_sym
              definition = RSpec.configuration
                .swagger_docs['v1/swagger.json'][:definitions][ref_name]
              definition[:example] ||= value.to_json
            else
              parameter[:schema][:example] ||= value
            end
          else
            parameter[:'x-example'] ||= value
          end
        end
      end
    end
  end
end