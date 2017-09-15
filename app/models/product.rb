class Product < ApplicationRecord
  
  has_many :order_items, dependent: :destroy
  has_many :quantity_levels, dependent: :destroy
  
  accepts_nested_attributes_for :quantity_levels, :allow_destroy => false #, :reject_if => lambda{ |a| a[:detail.blank?] }
  
  validates :name, :description, :quantity_available, presence: true
  validates_numericality_of :quantity_available, greater_than_or_equal_to: 0
  
  scope :publishable, -> { where(published: true) }
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/LexCares.png"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
        
end
