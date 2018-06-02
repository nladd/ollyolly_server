require Rails.root.join('app', 'services', 'yodlee_api').to_s

YodleeApi.configure do |config|
  config.base_url = 'https://developer.api.yodlee.com/ysl/'

  app_configs = YAML.load_file(Rails.root.join('config', 'yodlee_api.yml'))[Rails.env]

  config.username = app_configs['username']
  config.password = app_configs['password']

  # config.headers = {'Content-Type' => 'application/json', 'Api-Version' => '1.1', 'Cobrand-Name' => 'restserver'}
end
