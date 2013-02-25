require 'tempfile'

module MetaRequest
  class Storage
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def write(value)
      tempfiles[json_file].write(value)
    end

    def read
      if tempfiles.has_key?(json_file)
        tempfile = tempfiles[json_file]
        tempfile.rewind
        tempfile.read
      end
    end

    private

    def tempfiles
      @@tempfiles ||= Hash.new { |hash, key| hash[key] = Tempfile.new(key) }
    end

    def json_file
      "#{key}.json"
    end
  end
end
