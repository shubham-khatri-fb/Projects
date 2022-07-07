class RedisService
    def self.get_current_rates
        url = "https://v6.exchangerate-api.com/v6/#{Settings.CONVERSION_RATE_API_KEY}/latest/USD"
        response = RestClient.get(url)
        response = JSON.parse(response)
        return response
    end

    def self.set_values
        response = RedisService.get_current_rates
        REDIS.hmset(:convesion_rates, :inr, response["conversion_rates"]["INR"], :aud, response["conversion_rates"]["AUD"], :eur, response["conversion_rates"]["EUR"], :gbp, response["conversion_rates"]["GBP"], :usd, "1")
    end

    def self.get_conversion_rate(country_code)
        return REDIS.hget(:convesion_rates,country_code).to_f
    end
end