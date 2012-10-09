require 'rho/rhocontroller'
require 'digest/md5'

class MapController < Rho::RhoController
  #@layout = :simplelayout
  
  @@file_name = File.join(Rho::RhoApplication::get_base_app_path(), 'floorplan.pdf')
  @@file_name_md5 = File.join(Rho::RhoApplication::get_base_app_path(), 'floorplan.md5')
  
  def download_pdf
    puts "We need to download the file #{@@file_name}"
    
    if File.exists?(@@file_name)
      File.delete(@@file_name)
    end
    
    Rho::AsyncHttp.download_file(
      :url => 'http://rhohub-motorolasoluti-9dc0875a.rhosync.com/floorplanpdf',
      :filename => @@file_name,
      :headers => {},
      :callback => (url_for :action => :httpdownload_callback),
      :callback_param => ""
    )
  end
  
  def get_md5
    puts "We need to download the file #{@@file_name_md5}"
    
    # Delete the original MD5
    if File.exists?(@@file_name_md5)
      File.delete(@@file_name_md5)
    end
    
    Rho::AsyncHttp.download_file(
    :url => 'http://rhohub-motorolasoluti-9dc0875a.rhosync.com/floorplanmd5',
      :filename => @@file_name_md5,
      :headers => {},
      :callback => (url_for :action => :md5_callback),
      :callback_param => ""
    )
  end
  
  def md5_callback
    puts "md5_callback: #{@params}"
    
    if @params['status'] != 'ok'
      @@error_params = @params
      WebView.navigate( url_for :action => :show_error )
    else
      @local_digest = Digest::MD5.hexdigest(File.open(@@file_name, 'rb') {|fh| fh.read})
      # If we get here, we have the MD5 from the server and also the file.
      if @local_digest == File.read(@@file_name_md5).chomp
        # Instruct the webview to call our method show_result
        WebView.navigate(url_for :action => :show_result)
      else
        # MD5's don't match, so the file must have changed.
        download_pdf()
      end
    end
  end
  
  def index
    # Check if file already exists.  If it does, then just display it.
    if File.exists?(@@file_name)
      # Get the MD5 from the webserver
      get_md5()
    else
      download_pdf()
    end
  end
  
  def get_res
    @@file_name
  end
  
  def get_error
    @@error_params
  end
  
  def httpdownload_callback
    puts "httpdownload_callback: #{@params}"
    
    if @params['status'] != 'ok'
      @@error_params = @params
      WebView.navigate( url_for :action => :show_error )
    else
      WebView.navigate(url_for :action => :show_result)
    end
  end
  
  def show_result
    System.open_url(@@file_name)
    WebView.navigate(url_for :controller => :EMEA)
  end
  
  def show_error
    Alert.show_popup "Cannot log in to the RhoConnect server."
    WebView.navigate(url_for :controller => :EMEA)
    #render :action => :error, :back => '/app'
  end
  
  def cancel_httpcall
    puts "cancel_httpcall"
    Rho::AsyncHttp.cancel()# url_for( :action => :httpdownload_callback) )

    @@get_result  = 'Request was cancelled.'
    render :action => :index, :back => '/app'
  end  
end
