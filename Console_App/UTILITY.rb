require "json"

module Utility

    def self.get_json(json_file)

        contenido = File.read(json_file)
        json = JSON.parse(contenido)

        return json
    end

    #the text not can contain special characters or numbers and return true if the text is valid
    def self.is_valid_file_name(file_name)

        if file_name.match(/^[a-zA-Z0-9\s]*$/)
            return true
        end

        return false

    end

    def self.deep_freeze(hash)
        hash.each { |k, v| k.freeze; v.freeze }
        return hash.freeze
    end

end