class CacheService
  class << self
    def [](key)
      CachedUrl.find_by(url: key).response
    end
    
    def []=(key, value)
      existing_record = self[key]
      if existing_record
        existing_record.update(response: value)
      else
        CachedUrl.create(url: key, response: value)
      end
    end
    
    def delete(key)
      existing_record = self[key]
      if existing_record
        existing_record.destroy
      end
    end
    
    def keys
      CachedUrl.pluck(:url)
    end
  end
end