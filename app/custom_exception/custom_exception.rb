module CustomException
    class NotSufficientFundsToTransfer < StandardError
        def initialize
            super(msg = "Not Sufficients funds to make transfer")
        end
    end

    class RequiredParametersAreMissing < StandardError
        def initialize
            super(msg = "Required parameters are missings")
        end
    end

    class InvalidTransferAmount < StandardError
        def initialize
            super(msg = "Invalid transfer amount")
        end
    end

end