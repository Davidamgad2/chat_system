# spec/swagger_helper.rb

require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.to_s + "/swagger"

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1",
      },
      paths: {},
      servers: [
        {
          url: "#{Rails.application.config.host_url}",
          variables: {
            defaultHost: {
              default: "#{Rails.application.config.host_url}",
            },
          },
        },
      ],
    },
  }

  config.openapi_format = :yaml
end
