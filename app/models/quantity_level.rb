class QuantityLevel < ApplicationRecord
  
  validates :min_quantity, :max_quantity, :duration_per_user, :quantity_per_user, presence: true
  
  validates_numericality_of :min_quantity, :max_quantity, 
                            :duration_per_user, :quantity_per_user, 
                            only_integer: true, greater_than_or_equal_to: 0
  
  validate :max_greater_than_min
  
  belongs_to :user_level
  belongs_to :product
  
  private
  def max_greater_than_min
    if max_quantity.present? && min_quantity.present?
      if !min_quantity.zero? && (max_quantity <= min_quantity)
        errors.add(:max_quantity, "should be greater than minimum quantity")
      end
    end
  end
  
end
