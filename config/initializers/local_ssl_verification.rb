if ENV["SNAP_DISABLE_SSL_VERIFY"] == "true" && !Rails.env.production?
  require "net/http"
  require "openssl"

  module DisableLocalSslVerification
    def use_ssl=(flag)
      super
      self.verify_mode = OpenSSL::SSL::VERIFY_NONE if flag
    end
  end

  module DisableLocalSslContextVerification
    def set_params(params = {})
      super(params.merge(verify_mode: OpenSSL::SSL::VERIFY_NONE, verify_hostname: false))
    end
  end

  Net::HTTP.prepend(DisableLocalSslVerification)
  OpenSSL::SSL::SSLContext.prepend(DisableLocalSslContextVerification)
end
