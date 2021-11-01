require 'erb'
require 'fileutils'
module Polycon
    module Utils
        class Export

            def self.create_grid_day(date,array,prof=nil)
                template = %{<!DOCTYPE html>
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
                                    <li>(<%= elem[0] %>) <%= elem[1].name %> <%= elem[1].surname %> <%= elem[1].phone %> </li>  
                                <% end %>
                                </ul>
                            </td>
                        </tr>
                        <% end %>
                    </table>
                </body>
                </html>
                }

                rows = {"08:00"=> [], "08:30"=> [], "09:00"=> [], "09:30"=> [], "10:00"=> [], "10:30"=> [], "11:00"=>[], "11:30"=>[],
                "12:00"=> [], "12:30"=> [], "13:00"=> [], "13:30"=> [], "14:00"=> [], "14:30"=> [], "15:00"=> [], "15:30"=> [],
                "16:00"=> [], "16:30"=> [], "17:00"=> [], "17:30"=> [], "18:00"=> [], "18:30"=> [], "19:00"=> [], "19:30"=> [], "20:00"=> []}

                rows.each do |key,value|
                    datetime_bottom_limit = DateTime.strptime("#{date}_#{key}-03:00", "%Y-%m-%d_%H:%M%z")
                    datetime_top_limit = datetime_bottom_limit + Rational(30,(60*24))
                    array.delete_if do |element|
                        if (element[1].date >= datetime_bottom_limit) and (element[1].date < datetime_top_limit)
                            rows[key] << element
                        end
                    end
                end

                erb = ERB.new(template)
                output = erb.result_with_hash(rows: rows)

                if prof
                    file_name = "#{prof.tr(' ','-')}_#{date}.html"
                else
                    file_name = "#{date}.html"
                end

                FileUtils.mkdir_p "#{PATH2}day"
                File.open("#{PATH2}day/#{file_name}",'w') do |f|
                    f.write output
                end
            end

            def self.create_grid_week(date,array,prof=nil)
                template = %{<!DOCTYPE html>
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
                                    <li>(<%= elem[0] %>) <%= elem[1].name %> <%= elem[1].surname %> <%= elem[1].phone %> </li>  
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

                rows = {"08:00"=> [], "08:30"=> [], "09:00"=> [], "09:30"=> [], "10:00"=> [], "10:30"=> [], "11:00"=>[], "11:30"=>[],
                    "12:00"=> [], "12:30"=> [], "13:00"=> [], "13:30"=> [], "14:00"=> [], "14:30"=> [], "15:00"=> [], "15:30"=> [],
                    "16:00"=> [], "16:30"=> [], "17:00"=> [], "17:30"=> [], "18:00"=> [], "18:30"=> [], "19:00"=> [], "19:30"=> [], "20:00"=> []}
                
                rows.each {|key,value| rows[key] = [[],[],[],[],[],[],[]]}
                
                rows.each do |key,value|
                    datetime_bottom_limit = DateTime.strptime("#{date}_#{key}-03:00", "%Y-%m-%d_%H:%M%z")
                    datetime_top_limit = datetime_bottom_limit + Rational(30,(60*24))
                    array.delete_if do |element|
                        if (element[1].date.strftime("%H:%M") >= datetime_bottom_limit.strftime("%H:%M")) and (element[1].date.strftime("%H:%M") < datetime_top_limit.strftime("%H:%M"))
                            rows[key][(element[1].date.wday - 1)] << element
                        end
                    end
                end

                erb = ERB.new(template)
                output = erb.result_with_hash(rows: rows)

                if prof
                    file_name = "#{prof.tr(' ','-')}_#{date}.html"
                else
                    file_name = "#{date}.html"
                end

                FileUtils.mkdir_p "#{PATH2}week"
                File.open("#{PATH2}week/#{file_name}",'w') do |f|
                    f.write output
                end

            end
        end
    end
end