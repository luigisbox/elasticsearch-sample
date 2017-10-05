class Contract < ApplicationRecord
  self.table_name = 'crz.contracts'
  self.primary_key = 'id'

  belongs_to :department
  has_many :attachments
end
