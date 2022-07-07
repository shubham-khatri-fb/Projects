module CustomException
  
    class Validaton < StandardError
    end

    class RequiredParametersAreMissing < StandardError
    end

    class InvalidTransferAmount < StandardError
    end

end