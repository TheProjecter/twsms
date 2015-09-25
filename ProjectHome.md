# A newer version was available on Github: http://github.com/cfc/twsmsr/tree/master #

This is a Ruby library for TWSMS(http://www.twsms.com).

```
require 'twsms'
sms = TWSMS.new("username", "password")
sms.sendSMS(mobile, message)
sms.querySMS
sms.setMessageId(msgid)
sms.querySMS
```
