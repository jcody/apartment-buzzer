# Automagic Apartment Buzzer
Programmatically let guests into your apartment building without having to answer your buzzer, or worse, go downstairs to open the door. Add a little flair with a welcome message for guests and even get text alerts that a guest has arrived.

### Setup
Copy `.env.sample` to `.env`, adding your own [Twilio phone number](https://www.twilio.com/help/faq/phone-numbers) and API credentials.

```sh
$ bundle install
$ heroku create
$ git push heroku master
```
