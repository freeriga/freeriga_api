require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s
  config.include RequestSpecHelper
  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Free Riga API V1',
        version: 'v1'
      },
      paths: {},
      securityDefinitions: {
        client:         {
          in:   :header,
          name: :client,
          type: :apiKey
        },
        uid:            {
          in:   :header,
          type: :apiKey,
          name: :uid
        },
        "Access-Token": {
          in:   :header,
          type: :apiKey,
          name: 'Access-Token'
        }
      },
      security:            [
        { client: [] },
        { uid: [] },
        { 'Access-Token': [] }
      ],
      definitions:         {
        errors_object:       {
          type:       'object',
          properties: {
            errors: { '$ref' => '#/definitions/errors_map' }
          }
        },
        errors_map:          {
          type:                 'object',
          additionalProperties: {
            type:  'array',
            items: { type: 'string' }
          }
        },
        location_object:    {
          type:       'object',
          properties: {
            name:       { type: :string }
          },
          required: %w[name]
        },
        comment_object:   {
          type:     'object',
          properties: {
            username:    { type: :string },
            location_id: { type: :number },
            colour:      { type: :string },
            body:        { type: :string }
          },
          required: %w[username location_id colour body]
        },
        task_object:    {
          type:     'object', 
          properties:   {
            username:         { type: :string },
            user_location_id: { type: :number },
            location_id:      { type: :number },
            status:           { type: :number },
            colour:           { type: :string },
            summary:          { type: :string }
          },
          required: %w[username colour user_location_id status]
        }
      }
    }
  }
end
