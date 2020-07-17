class IncomeStatement < ApplicationRecord
	belongs_to :company
	belongs_to :source_file
end
