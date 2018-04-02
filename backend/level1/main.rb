require 'json'
require 'date'

# Helper class to handle all read/write/validation
# Regarding json and file interactions
class JsonHelper

    # We will never instanciate this class
    class << self

        # Read a local level data/input.json file
        # Returns a hash or false on failure
        def readFileToHash()
            begin
                file = File.read("data/input.json")
                data_hash = JSON.parse(file)
            rescue
                puts "Failed to open and parse file data/input.json\n"
                return false
            end

            return data_hash
        end

        # Write a hash into a local level data/output.json file
        # Return true/false on success/failure
        def writeHashtoFile(hash)
            begin
                File.open("data/output.json","w") do |f|
                    f.write(JSON.pretty_generate(hash))
                end
            rescue
                puts "Failed to write #{hash}\n"
                return false
            end

            return true
        end
    end
end

data = JsonHelper.readFileToHash()
output = {'rentals' => []}

data['rentals'].each do |rental|
    nb_day = (Date.parse(rental['end_date']) - Date.parse(rental['start_date'])).to_i
    
    related_car = data['cars'].find{|car| car['id'] == rental['car_id']}
    
    output['rentals'] <<
    {
        'id' => rental['id'],
        'price' => related_car['price_per_day']*nb_day + related_car['price_per_km']*rental['distance']
    }
end

JsonHelper.writeHashtoFile(output)
