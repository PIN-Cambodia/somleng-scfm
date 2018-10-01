require "selenium/webdriver"

Capybara.server = :puma, {silent: true}

#Capybara.register_driver :selenium_chrome do |app|
#  Capybara::Selenium::Driver.new(app, browser: :chrome)
#end

capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  chromeOptions: { args: %w[headless disable-gpu no-sandbox] }
)

# If we're using a remote selenium host, set this up
if ENV['SELENIUM_REMOTE_HOST'].present?
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
      desired_capabilities: capabilities
  end
  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = 3001
else
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      desired_capabilities: capabilities
  end
end

Capybara.javascript_driver = :chrome

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    if ENV['SELENIUM_REMOTE_HOST'].present?
      Capybara.app_host = "http://#{`hostname -s`.strip}:#{Capybara.server_port}"
    end
    driven_by :chrome
  end

  #config.before(:each, type: :system, selenium_chrome: true) do
  #  Capybara.app_host = "http://localhost:#{Capybara.current_session.server.port}"
  #  driven_by :selenium, using: :chrome
  #end

end
