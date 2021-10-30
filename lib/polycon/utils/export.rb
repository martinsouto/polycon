require 'erb'
require 'fileutils'
module Polycon
    module Utils
        class Export

            def self.create_grid_day(date,dic,prof=nil)
                template = %{<!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <title>Document</title>
                </head>
                <body>
                    <p>Probando<p>
                    <%= dic %>
                </body>
                </html>
                }

                erb = ERB.new(template)
                output = erb.result_with_hash(dic: dic)

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
        end
    end
end