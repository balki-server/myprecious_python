require 'nokogiri'
require 'open-uri'
require 'date'
require 'byebug'

class MyPreciousPython
  def self.update
    file = File.new("Packages", "r")

    File.open('dependency-tracking.md', 'w') { |write_file|
      write_file.puts "dependency | Our Version | Latest Version | Date available | Age (in days) | Change Log"
      write_file.puts "--- | --- | --- | --- | --- | ---"
      while (line = file.gets)
        gem_line = line.strip
        name = gem_line.split('==')[0]
        current_version = gem_line.split('==')[1]
        latest_version_string = %x(yolk -U #{name})
        begin
          latest_version = latest_version_string.split(' ')[2].split("(")[1].split(")")[0]
        rescue
          latest_version = current_version
        end
        scrape_url = "https://pypi.python.org/pypi/" + name.to_s + "/" + current_version.to_s
        doc = Nokogiri::HTML(open(scrape_url))
        doc_data = doc.css('tr.odd td')
        if !doc_data.nil?
          current_build_date = doc_data[3].content
        else
          current_build_date = ""
        end

        scrape_url = "https://pypi.python.org/pypi/"+name+"/"+latest_version
        doc = Nokogiri::HTML(open(scrape_url))
        doc_data = doc.css('tr.odd td')
        if !doc_data.nil?
          latest_build_date = doc_data[3].content
        else
          latest_build_date = ""
        end

        begin
          documentation = doc.at('li:contains("Documentation:")').css('a').map { |link| link['href'] }[0]
        rescue Exception => e
          documentation = ""
        end

        begin
          homepage_uri = doc.at('li:contains("Home Page")').text.strip.split("\n").last.strip
        rescue Exception => e
          homepage_uri = ""
        end

        days_complete = Date.parse(latest_build_date) - Date.parse(current_build_date)

        write_file.puts "[" + name + "]" + "(" + homepage_uri.to_s  + ")" + 
                        "|" + current_version.to_s + "|" + latest_version.to_s + "|" +
                        (latest_build_date).to_s + "|" + days_complete.to_i.to_s + "|" +
                        documentation.to_s
      end
      file.close

    }
  end
end
