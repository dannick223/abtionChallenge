module Api
  module V1
    class ScrappersController < ApplicationController
      def index
        # Checks if parameters for dates are present, if not set dates to current date.
        # Check if date is earlier than current date and check if date is not older than 2 days.
        if params.key?(:flight_time)
          event = params[:flight_time]
          d = Date.new event['date(1i)'].to_i,
                       event['date(2i)'].to_i,
                       event['date(3i)'].to_i
          @date = d.strftime('%d-%m-%Y')
          if Date.today - 1 >= Date.parse(@date) || Date.today + 2 < Date.parse(@date)
            @date_error = 'Only possible to see flights 48 hours ahead of time ' + @date
          else
            @date = d.strftime('%d-%m-%Y')
            @date_error = ''
          end
        else
          @date_formatted = Date.today.strftime('%d-%m-%Y')
          @date = Date.today
          @date_error = ''
        end

        # Check if the time parameter is present if not set time to 00:00
        # Check if parameter is an integer
        if params.key?(:time)
          t = params[:time]
          t.is_a? Integer
          time = t
        else
          time = '00'
        end

        # Set baseurl depending of the type parameter.
        # fallback to first option incase of breakage.
        # use the gem HTTParty to fetch the html of baseurl
        # use the gem nokogiri to render the html as requested on the view
        type = params[:type]
        baseurl = if type == 'Afgange'
                    flash[:type] = "Searching for afgange"
                    'https://www.cph.dk/flyinformation/afgange'
                  elsif type == 'Ankomster'
                    flash[:type] = "Post successfully ankomster"
                    'https://www.cph.dk/flyinformation/ankomster'
                  else
                    flash[:type] = "Searching for afgange"
                    'https://www.cph.dk/flyinformation/afgange'
                  end
        html = HTTParty.get(baseurl.to_s,
                            query: { q: params[:q], date: @date, time: time })
        @noko = Nokogiri::HTML(html)
      end
    end
  end
end
