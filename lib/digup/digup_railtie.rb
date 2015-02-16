module Digup
  class DigupRailtie < Rails::Railtie
    initializer "digup.configure_rails_initialization" do |app|
      app.middleware.use Digup::Rack
    end
  end
 end
