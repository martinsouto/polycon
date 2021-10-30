require 'erb'
require 'fileutils'
module Polycon
    module Utils
        class Export
            def self.algo
                puts PATH2
            end

            def self.create_grid_day(date,dic,prof=nil)
                template = %{<!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <title>Document</title>
                </head>
                <body>
                    <p>Holaaaa <%= date %><p>
                    <%= dic %>
                </body>
                </html>
                }

                erb = ERB.new(template)
                output = erb.result()

                if prof
                    file_name = "#{prof}_#{date.strftime("%d-%m-%Y_%H-%M")}.html"
                else
                    file_name = "#{date.strftime("%d-%m-%Y_%H-%M")}.html"

                FileUtils.mkdir_p "#{PATH2}day"
                File.open("#{PATH2}day/#{file_name}",'w') do |f|
                    f.write output
                end
            end
        end
    end
end