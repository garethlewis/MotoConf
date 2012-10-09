require 'rho/rhoapplication'
require 'rho/rhocontroller'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    #To remove default toolbar uncomment next line:
    @@toolbar = nil
    
    @default_menu = { Rho::RhoMessages.get_message('home_menu') => :home, Rho::RhoMessages.get_message('refresh_menu') => :refresh, 
      Rho::RhoMessages.get_message('close_menu') => :close }
    super
    
    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
    
    # Problem here, if the application cannot log in, then we cannot sync.
    SyncEngine.login("a", "a", "/app/Settings/login_callback")
    
    Rho::NativeToolbar.remove
  end
end
