require 'fileutils'
require 'erb'
class ExportController < ApplicationController
  before_action :set_day_template, only: %i[ export_day ]
  before_action :set_week_template, only: %i[ export_week ]
  before_action :set_rows, only: %i[ export_day export_week ]
  before_action :authenticate_user!
  def index
  end

  def day
  end

  def week
  end

  def export_day
    date = Date.strptime(params[:date], "%Y-%m-%d")
    if params[:name] == "-"
      aps = Appointment.in_day(date)
      file_name = "#{date}_day.html"
    else
      prof = Professional.find_by(name: params[:name])
      aps = prof.appointments.in_day(date)
      file_name = "#{params[:name].tr(' ','-')}_#{date}_day.html"
    end
    array = aps.to_a
    
    @rows.each do |key,value|
      datetime_bottom_limit = DateTime.strptime("#{params[:date].to_s}_#{key}-03:00", "%Y-%m-%d_%H:%M%z")
      datetime_top_limit = datetime_bottom_limit + Rational(30,(60*24))
      array.delete_if do |element|
          if (element.date >= datetime_bottom_limit) and (element.date < datetime_top_limit)
              @rows[key] << element
          end
      end
    end

    erb = ERB.new(@template)
    output = erb.result_with_hash(rows: @rows)
    send_data(output, :filename => file_name)
  end

#-------------------------------------------------------------------------

  def export_week
    date = (Date.strptime(params[:date], "%Y-%m-%d")).beginning_of_week
    if params[:name] == "-"
      aps = Appointment.in_week(date)
      file_name = "#{date}_week.html"
    else
      prof = Professional.find_by(name: params[:name])
      aps = prof.appointments.in_week(date)
      file_name = "#{params[:name].tr(' ','-')}_#{date}_week.html"
    end
    array = aps.to_a
    
    @rows.each {|key,value| @rows[key] = [[],[],[],[],[],[],[]]}

    @rows.each do |key,value|
      datetime_bottom_limit = DateTime.strptime("#{params[:date].to_s}_#{key}-03:00", "%Y-%m-%d_%H:%M%z")
      datetime_top_limit = datetime_bottom_limit + Rational(30,(60*24))
      array.delete_if do |element|
          if (element.date.strftime("%H:%M") >= datetime_bottom_limit.strftime("%H:%M")) and (element.date.strftime("%H:%M") < datetime_top_limit.strftime("%H:%M"))
              @rows[key][(element.date.wday - 1)] << element
          end
      end
    end

    erb = ERB.new(@template)
    output = erb.result_with_hash(rows: @rows)
    send_data(output, :filename => file_name)
  end

  private

    def set_day_template
      @template = %{<!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <title>Polycon Grid</title>
      </head>
      <body>
          <table border="1">
              <tr>
                  <th>Hora</th>
                  <th>Turno</th>
              </tr>
              <% rows.each do |key,value| %>
              <tr>
                  <td><%= key %></td>
                  <td>
                      <ul>
                      <% value.each do |elem| %>
                          <li>(<%= elem.professional.name %>) <%= elem.first_name %> <%= elem.last_name %> - <%= elem.phone %> - <%= elem.date.strftime("%H:%M") %></li>  
                      <% end %>
                      </ul>
                  </td>
              </tr>
              <% end %>
          </table>
      </body>
      </html>
      }
    end
    
    def set_rows
      @rows = {"00:00"=> [], "00:30"=> [], "01:00"=> [], "01:30"=> [], "02:00"=> [], "02:30"=> [], "03:00"=>[], "03:30"=>[],
        "04:00"=> [], "04:30"=> [], "05:00"=> [], "05:30"=> [], "06:00"=> [], "06:30"=> [], "07:00"=>[], "07:30"=>[],
        "08:00"=> [], "08:30"=> [], "09:00"=> [], "09:30"=> [], "10:00"=> [], "10:30"=> [], "11:00"=>[], "11:30"=>[],
        "12:00"=> [], "12:30"=> [], "13:00"=> [], "13:30"=> [], "14:00"=> [], "14:30"=> [], "15:00"=> [], "15:30"=> [],
        "16:00"=> [], "16:30"=> [], "17:00"=> [], "17:30"=> [], "18:00"=> [], "18:30"=> [], "19:00"=> [], "19:30"=> [], "20:00"=> [],
        "20:30"=>[], "21:00"=>[], "21:30"=>[], "22:00"=>[], "22:30"=>[], "23:00"=>[], "23:30"=>[]} 
    end

    def set_week_template
      @template = %{<!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <title>Polycon Grid</title>
      </head>
      <body>
          <table border="1">
              <tr>
                  <th>Hora/Día</th>
                  <th>Lunes</th>
                  <th>Martes</th>
                  <th>Miércoles</th>
                  <th>Jueves</th>
                  <th>Viernes</th>
                  <th>Sábado</th>
                  <th>Domingo</th>
              </tr>
              <% rows.each do |key,value| %>
              <tr>
                  <td><%= key %></td>
                  <% value.each do |apps| %>
                  <td>
                      <ul>
                      <% apps.each do |elem| %>
                          <li>(<%= elem.professional.name %>) <%= elem.first_name %> <%= elem.last_name %> - <%= elem.phone %> - <%= elem.date.strftime("%H:%M") %></li>  
                      <% end %>
                      </ul>
                  </td>
                  <% end %>
              </tr>
              <% end %>
          </table>
      </body>
      </html>
      }
    end
end
