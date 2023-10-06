class CacheService
  class << self
    def find_record key
      CachedUrl.find_by(url: key)
    end

    def [](key)
      find_record(key).try(:response)
    end
    
    def []=(key, value)
      existing_record = find_record(key)
      if existing_record
        existing_record.update(response: value)
      else
        CachedUrl.create(url: key, response: value)
      end
    end
    
    def delete(key)
      find_record(key).try(:destroy)
    end
    
    def keys
      CachedUrl.pluck(:url)
    end
  end
end