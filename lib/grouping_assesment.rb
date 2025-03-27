# frozen_string_literal: true

require 'csv'
class GroupingAssessment
  attr_reader :input_file, :matching_type, :group_index, :group_counter

  def initialize(input_file, matching_type)
    @input_file = input_file
    @matching_type = matching_type
    @group_index = {}
    @group_counter = 1
  end

  def group_records
    CSV.open(output_file_name, 'w', write_headers: true, headers: output_csv_headers) do |csv_out|
      CSV.foreach(input_file, headers: true) do |row|
        keys = extract_keys(row)
        group_id = find_or_assign_group(keys)
        keys.each { |key| group_index[key] = group_id }
        row = { 'Person ID' => group_id }.merge(row.to_h)

        csv_out << row
      end
    end
  end

  private

  def output_file_name
    "output_#{matching_type}_#{File.basename(input_file)}"
  end

  def output_csv_headers
    @output_csv_headers ||= ['Person ID'] + CSV.open(input_file, 'r', &:readline)
  end

  def extract_keys(row)
    grouping_columns.map do |col_name|
      value = row[col_name].to_s.strip
      col_name.include?('Phone') ? value.gsub(/\D/, '') : value
    end.compact.reject(&:empty?)
  end

  def find_or_assign_group(keys)
    keys.each { |key| return group_index[key] if group_index.key?(key) }
    group_counter.tap { @group_counter += 1 }
  end

  def grouping_columns
    @grouping_columns ||= output_csv_headers.select do |header|
      case matching_type
      when 'same_email' then header.include?('Email')
      when 'same_phone' then header.include?('Phone')
      when 'same_email_or_phone' then header.include?('Email') || header.include?('Phone')
      end
    end
  end
end
