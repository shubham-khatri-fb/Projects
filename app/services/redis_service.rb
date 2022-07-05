require 'rest-client'
require 'net/http'
require 'json'
require 'redis'
class RedisService
    require 'redis'
    @@redis = Redis.new
    def self.get_current_rates
        url = "https://v6.exchangerate-api.com/v6/71dc75fad490c969174c1617/latest/USD"
        response = RestClient.get(url)
        response = JSON.parse(response)
        return response
    end

    def self.set_values
        redis = Redis.new
        @@redis.set("usd", 1)
        response = RedisService.get_current_rates
        @@redis.set("inr",response["conversion_rates"]["INR"])
        @@redis.set("aud",response["conversion_rates"]["AUD"])
        @@redis.set("eur",response["conversion_rates"]["EUR"])
        @@redis.set("gbp",response["conversion_rates"]["GBP"])
    end

    def self.get_conversion_rate(country_code)
        return @@redis.get(country_code).to_f
    end
end