module MerchantScope
  extend ActiveSupport::Concern

  included do
    scope :of, ->(user){ user.super_admin? ? where({}) : where(merchant_id: user.merchant_id) }
  end
end