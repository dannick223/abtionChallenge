module Api
  module V1
    class ScrappersController < ApplicationController
      def index
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

        if params.key?(:time)
          t = params[:time]
          t.is_a? Integer
          time = t
        else
          time = '00'
        end

        @date_fomatted = 'test'
        @type = params[:type]
        baseurl = if @type == 'Afgange'
                    'https://www.cph.dk/flyinformation/afgange'
                  elsif @type == 'Ankomster'
                    'https://www.cph.dk/flyinformation/ankomster'
                  else
                    'https://www.cph.dk/flyinformation/afgange'
                  end
        html = HTTParty.get(baseurl.to_s,
                            query: { q: params[:q], date: @date, time: time })
        @noko = Nokogiri::HTML(html)
      end
    end
  end
end
