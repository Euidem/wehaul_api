class TripRequest < ApplicationRecord
  include Tokenable
  enum status: [:pending, :in_negotiation, :on_going, :completed, :cancelled]
  belongs_to :user
  belongs_to :vehicle_type
  has_many :trip_activities, dependent: :destroy
  has_many :driver_requests, dependent: :destroy
  has_many :trackings, dependent: :destroy
  validates_presence_of :fee, :weight, :pickup_time, :pickup_date, :quantity
  after_create :set_status
  default_scope {order('created_at DESC')}
  
  def set_status
    self.update(status: 'pending') if !self.status
  end
  def self.trips 
    self.where.not(driver_id: nil)
  end

  def self.requests
    self.where(driver_id:nil)
  end

  def self.active
    self.where(status: 'pending').or(self.where(status:'on_going'))
  end
end
