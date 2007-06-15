=begin
  == Information ==
  === Copyright: Apache 2.0
  === Author: CFC < zusocfc@gmail.com >
  === Prog. Name: TWSMS lib
  === Version: 0.1
  == Introduction ==
    TWSMS(Taiwan SMS)
    TWSMS is a SMS sender, it must use with http://www.twsms.com.
    There has no any library for the SMS system in Taiwan. So, I just coded this and release this version.
    This version just support for sending SMS.
  == Featured ==
    
  == Using TWSMS ==
    It just support for standalone class now.
    require it before you use.
  === Using TWSMS by standalone class
    require 'twsms'
    sms = TWSMS.new('username', 'password')
    sms.sendSMS('09xxxxxxxx', 'Hi, there! TWSMS library is so easy to use!')
    sms.sendSMS('09xxxxxxxx', 'Send SMS with options',
        :popup => 1,
        :type => "now",
        :mo => "Y")
=end

%w|uri cgi net/http|.each{|r| require r}

class TWSMS
  def initialize(username, password)
    @uname, @upwd = username, password
    @options = {
      :type => "now", # Sending type: now, vld
      :popup => "",
      :mo => "Y".upcase,
      :vldtime => "86400",
      :modate => "",
      :dlvtime => "",
      :wapurl => "",
      :encoding => "big5"
    }
    
    @errors = {
      -1.to_s.to_sym => "Send failed",
      -2.to_s.to_sym => "Username or password is invalid",
      -3.to_s.to_sym => "Popup tag error",
      -4.to_s.to_sym => "Mo tag error",
      -5.to_s.to_sym => "Encoding tag error",
      -6.to_s.to_sym => "Mobile tag error",
      -7.to_s.to_sym => "Message tag error",
      -8.to_s.to_sym => "vldtime tag error",
      -9.to_s.to_sym => "dlvtime tag error",
      -10.to_s.to_sym => "You have no point",
      -11.to_s.to_sym => "Your account has been blocked",
      -12.to_s.to_sym => "Type tag error",
      -13.to_s.to_sym => "You can't send SMS message by dlvtime tag if you use wap push",
      -14.to_s.to_sym => "Source IP has no permission",
      -99.to_s.to_sym => "System error!! Please contact the administrator, thanks!!"
    }
    @args = []
    @url ||= "http://api.twsms.com/send_sms.php?"
    @url += "username=" + @uname
    @url += "&password=" + @upwd
  end
  
  def sendSMS(mobile, message, opt={})
    @options[:mobile], @options[:message] = mobile, message
    @options.merge!(opt).each{|k, v| @args << k.to_s + "=" + CGI::escape(v.to_s)}
    @url += "&" + @args.join("&")
    self.chk_val
    chk_errors(Net::HTTP.get(URI.parse(@url)))
  end
  
  def chk_val
    @options[:dlvtime] = "" unless @options[:type] == "dlv"
    @options[:wapurl] = "" if @options[:type] != ("push" && "upush")
  end
  
  def chk_errors(resp)
    resp = resp.split("=")[1]
    if @errors.has_key?(resp.to_s.to_sym)
      puts "==========", "Error!! Message: ", @errors[resp.to_s.to_sym]
    else
      puts "==========", "Message has been send! Your message id is: " + resp.to_s
    end
  end
  
  protected :chk_val
end