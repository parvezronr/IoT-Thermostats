include Swagger::Docs::ImpotentMethods

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    "/api/v1/#{path}"
  end
end

class Swagger::Docs::Config
  def self.base_api_controller
    ApiBaseController
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    api_extension_type: :json,
    # the output location where your .json files are written to
    api_file_path: "public/api/v1/",
    # the URL base path to your API
    base_path: IOT_THERMOSTAT_SETTINGS[:url],
    # if you want to delete all .json files at each generation
    clean_directory: false,
    base_api_controller: ApiBaseController,
  }
})