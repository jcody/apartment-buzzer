# Automagic Apartment Buzzer
Programmatically let guests into your apartment building without having to answer your buzzer, or worse, go downstairs to open the door. Add a little flair with a welcome message for guests and even get text alerts that a guest has arrived.

### Setup
Copy `.env.sample` to `.env`, adding your own [Twilio phone number](https://www.twilio.com/help/faq/phone-numbers) and API credentials.

```shell
$ bundle install
$ heroku create
$ git push heroku master
```

### Landlord Home
Toggle to forward call directly to your cell phone if your landlord will be testing the buzzer. If set to false, it will automagically let your guests in.

Set with [heroku config vars](https://devcenter.heroku.com/articles/config-vars):
```shell
heroku config:set LANDLORD_HOME=false
```
Alternatively, setting `LANDLORD_HOME=true` will forward the buzzer call to the number set in the `RESIDENT_PHONE_NUMBER` environment variable.
