require Rails.root.join('app', 'services', 'yodlee_api').to_s

YodleeApi.configure do |config|
  config.base_url = 'https://developer.api.yodlee.com/ysl/'

  yodlee_config = YAML.load_file(Rails.root.join('config', 'yodlee_api.yml'))[Rails.env]

  config.username = yodlee_config['account']['username']
  config.password = yodlee_config['account']['password']

  config.fastlink_app_id = yodlee_config['fastlink']['appId']
  config.fastlink_url = yodlee_config['fastlink']['url']

  # config.headers = {'Content-Type' => 'application/json', 'Api-Version' => '1.1', 'Cobrand-Name' => 'restserver'}
end
