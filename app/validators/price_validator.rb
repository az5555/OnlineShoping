class PriceValidator < ActiveModel::Validator
  def validate(record)
    Rails.logger.debug("Validating record: #{record.inspect}")
    if !record.price_before.nil? && !record.price.nil? && record.price_before <= record.price
      record.errors[:base] << "原价必须大于标价"
    end
  end
end