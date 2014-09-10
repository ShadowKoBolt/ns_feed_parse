module NumbersHelper
  def percentage_change(num_1, num_2)
    num_1 = num_1.to_f
    num_2 = num_2.to_f
    difference = num_2 - num_1
    percentage = (difference/num_1) * 100.0
    percentage.round
  end

  def percentages_of_total(rows)
    column_count = rows[0].count
    ret = rows.collect{|row| [row[0]] }
    (1..(column_count-1)).each do |current_column|
      total = rows.collect{|row| row[current_column].to_f }.sum
      rows.each_with_index do |row,index|
        ret[index] << ((row[current_column].to_f / total.to_f) * 100.0).round
      end
    end
    ret
  end
end
