require 'tempfile'

module MetaRequest
  class Storage
    attr_reader :key

    POOL_SIZE = 20

    def initialize(key)
      @key = key
    end

    def write(value)
      tempfiles[json_file].write(value).tap do
        while tempfiles.size > POOL_SIZE
          k, v = tempfiles.shift
          v.close
          v.unlink
        end
      end
    end

    def read
      if tempfiles.has_key?(json_file)
        tempfile = tempfiles[json_file]
        tempfile.rewind
        tempfile.read
      else
        ''
      end
    end

    def self.clean
      while !tempfiles.empty?
        k, v = tempfiles.shift
        v.close
        v.unlink
      end
    end

    private

    def self.tempfiles
      @tempfiles ||= Hash.new { |hash, key| hash[key] = Tempfile.new(key) }
    end

    def tempfiles
      self.class.tempfiles
    end

    def json_file
      "#{key}.json"
    end
  end
end
