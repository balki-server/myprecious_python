require 'date'
require 'byebug'
require 'httparty'
require 'json'
require 'rest-client'

class MyPreciousPython
  def self.update
    gem_lines = {}
    gem_name_pos = 0
    gem_version_pos = 1
    gem_latest_pos = 2
    gem_date_pos = 3
    gem_age_pos = 4
    gem_change_pos = 5
    default_length = 6
    if File.file?('dependency-tracking.md')
      puts "reading the dependency file...."
      File.open("dependency-tracking.md", "r").each_with_index do |line, line_number|
        #puts line + " dds " + line_number.to_s
        word_array = line.split('|')
        if line_number == 0
          default_length = word_array.size
          word_array.each_with_index do |word, index|
            if word.strip == 'Dependency'
              gem_name_pos = index
            elsif word.strip == 'Our Version'
              gem_version_pos = index
            elsif word.strip == 'Latest Version'
              gem_latest_pos = index
            elsif word.strip == 'Date available'
              gem_date_pos = index
            elsif word.strip == 'Age (in days)'
              gem_age_pos = index
            elsif word.strip == 'Change Log'
              gem_change_pos = index
            end
          end
        elsif line_number > 1
          gem_name_index = word_array[gem_name_pos].strip
          #extract just the name of the gem from the first column
          #since that column contains a markdown-formatted hyperlink
          gem_name_index = gem_name_index[/\[(.*?)\]/,1]
          gem_lines[gem_name_index] = line_number
        end

      end
      #puts gem_lines
    else
      puts "creating the dependency file...."
      File.open('dependency-tracking.md', 'w') { |write_file|
        write_file.puts "Dependency | Our Version | Latest Version | Date available | Age (in days) | Change Log"
        write_file.puts "--- | --- | --- | --- | --- | ---"
      }
    end

    file = File.new("Packages", "r")

    final_write = File.readlines('dependency-tracking.md')

    while (line = file.gets)
      gem_line = line.strip
      
      if !gem_line.start_with?('#') && !gem_line.start_with?("https://")
        begin
          if gem_line.include? "=="
            name = gem_line.split('==')[0]
            current_version = gem_line.split('==')[1] 
          elsif gem_line.include? ">="
            name = gem_line.split('>=')[0]
            current_version = gem_line.split('>=')[1] 
          elsif gem_line.include? "<="
            name = gem_line.split('<=')[0]
            current_version = gem_line.split('<=')[1] 
          end
          if !current_version.index(';').nil?
            current_version = current_version.split(';')[0]
          end  

          api_url = "https://pypi.python.org/pypi/" + name + "/" + "json"
          response = RestClient.get(api_url)
          puts name.to_s + ": gathering info @ " + api_url
          begin
            current_build_date = JSON.parse(response)['releases'][current_version][0]['upload_time']
            if !current_build_date.nil?
              current_build_date = current_build_date
            else
              current_build_date = ""
            end
          rescue Exception => e
            puts e
            current_build_date = ""
          end
          
          begin
            latest_version = JSON.parse(response)['info']['version']
          rescue
            puts e
            latest_version = ""
          end          
                    
          begin
            latest_build_date = JSON.parse(response)['releases'][latest_version][0]['upload_time']
            if !latest_build_date.nil?
              latest_build_date = latest_build_date
            else
              latest_build_date = ""
            end
          rescue Exception => e
            puts e
            latest_build_date = ""
          end

          begin
            documentation = JSON.parse(response)['info']['project_url']
          rescue Exception => e
            puts e
            documentation = ""
          end

          begin
            homepage_uri = JSON.parse(response)['info']['home_page']
          rescue Exception => e
            puts e
            homepage_uri = ""
          end

          begin
            days_complete = Date.parse(latest_build_date) - Date.parse(current_build_date)
          rescue Exception => e
            days_complete = 0
          end 
           
          if gem_lines[name].nil?
            array_to_write = Array.new(default_length) { |i| "" }
          else
            array_to_write = final_write[gem_lines[name]].split('|')
          end
          array_to_write[gem_name_pos] = "[" + name + "]" + "(" + homepage_uri.to_s  + ")"
          array_to_write[gem_version_pos] = current_version.to_s
          array_to_write[gem_latest_pos] = latest_version.to_s
          array_to_write[gem_date_pos] = (latest_build_date).to_s
          array_to_write[gem_age_pos] = days_complete.to_i.to_s

          array_to_write[gem_change_pos] = documentation.to_s.to_s + "\n"
          if !gem_lines[name].nil?
            final_write[gem_lines[name]] = array_to_write.join("|")
          else
            final_write << array_to_write.join("|")
          end
        rescue Exception => e
          puts e
        end
      end
    end
    File.open('dependency-tracking.md', 'w') { |f| f.write(final_write.join) }
    file.close
  end
end
