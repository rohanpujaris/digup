# Digup

Digup is a simple gem for debugging errors by printing outputs.
Digup allows you to debug your application by printing everything in html page or web console. Digup have diffrent logging mode file, db logging and logging data directly to console and html page.
It is a gem for those who still follow old debugging techniques of printing output and inspecting bug by using methods like 'puts' and 'p'. Digup can also be used as logger as it alows logging data to file.

## Installation

Add this line to your application's Gemfile:

    gem 'digup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install digup

## Dependencies
Digup requires rails( 4.2 < version > 3.0). It also requires jquery for handling log for js and json request

## Note
- Digup modifies json when Digup is used to get json response. It appends data to json. If application is calculating number of object inside json data or doing other manipulation then the manipulation may get affected.
- If you are using firebug and 'track throw catch' is enable under script it may catch the exception throw. You can disable it so that it doesn't respond to exception already caught by Digup.

## Usage

Digup have several settings to be set to operate diffrently.
Once gem is installed go to config/environment/development.rb file and configure the gem. Paste following code

      config.after_initialize do
         Digup::Setting.options = :default
      end

Above setting will make Digup operate with default setting

After you have configured Digup gem you can use digup_write method to out data you want.

     digup_write 'Print this to web console and other places'

Digup uses following setting as default

        Digup::Setting.options = {
          :response_type => [:js, :json, :html],
          :log_to => [:console, :html_body],
          :cursor_info => true
        }

You can configure digup to operate the way you want.
- response_type: It takes single value as symbol or array of symbols to specify multiple options. It sets response_type for which the log will be sent

     eg) If it includes :json, then log will be appended to json response otherwise it would not be appended

     Possible options for response type are :js, :json, :html

     If  request for 'script'(i.e 'accepts' header of request header is text/javascript, application/javascript) is made to a server and server returns html instead of javascript then Digup might not work as accepted. In this case we need to specify response that server will send as digup_log second parameter

     eg) digup_log 'Print this', :html

     We need to use second parameter only once and for subsequent use of digu_log method in same controller action we can be skip second parameter. We can also use method set_digup_response to set response type as

     eg) set_digup_response :html

     Note: Above condition may occur when we use jquery dataType: 'script' in ajax call and server returns html. We can also specify second parameter as :js or :json if 'accepts' parameter of request header is different from the server response type(i.e is 'accepts' in request header is html and server is sending json)

- log_to: It takes single value as symbol or array of symbol to specify multiple options. It sets places where the output should be logged.

     Possible options
     1. :console => When this option is used then the data printed through digup_write method is shown on browser web console.
     2. :html_body => When this option is used then the data printed through digup_write method is displayed as footer in web page. You can generate default view that the digup provides using digup:view generator. It is recommended to generate the default view if this option is to be used.

            rails generate digup:view
     Above command will generate file named _hook.html.erb inside app/views/diup folde. This view will be apended to html page when :html_body option is set. You can customize this view as you want.
     3. :db => When this option is used then the data printed through digup_write method is stored in database. Before you can use this option you should generate model and migration file required. You can do this using digup:model generators.

             rails generate digup:model
Above command will generate two model file(digup_write.rb, request_response_info.rb) and corresponding migration files. You should run migration before you can use :db option

     NOTE => If you are using :db option ActiveRecord is mandatory.

     4. :file => When this option is used then the data printed through digup_write method is logged inside digup.log file. digup.log is inside log folder.

- cursor_info => If this option is true then file name along with the line number where digup_write method was used will be diplayed along with message that is printed.

If :db or :file logging is used then some extra information is also logged. Extra informations logged are request method(get, post, put etc), request accepts([text/html, application/xml, */*] etc), response status(it would always 200), response type(text/html, application/json etc), params


## License

Licensed under the MIT license, see the separate LICENSE.txt file.
