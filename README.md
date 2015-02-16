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

     Possible options for responset type are :js, :json, :html
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
