module NumbersHelper
  def percentage_change(num_1, num_2)
    num_1 = num_1.to_f
    num_2 = num_2.to_f
    difference = num_2 - num_1
    percentage = (difference/num_1) * 100.0
    percentage.round
  end

  def percentages_of_total(column)
  end
end
