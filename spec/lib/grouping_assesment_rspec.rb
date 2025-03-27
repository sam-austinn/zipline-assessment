# frozen_string_literal: true

require 'csv'
require_relative '../../lib/grouping_assesment'

RSpec.describe GroupingAssessment do
  let(:input_file) { 'test_input.csv' }
  let(:matching_type) { 'same_phone' }
  let(:grouping_assessment) { described_class.new(input_file, matching_type) }
  let(:output_file) { grouping_assessment.send(:output_file_name) }

  before do
    CSV.open(input_file, 'w', write_headers: true, headers: %w[Name Phone1 Phone2 Email1 Email2]) do |csv|
      csv << ['Alice', '123-456-7890', '', 'alice@example.com', '']
      csv << ['Bob', '987-654-3210', '123-456-7890', 'bob@example.com', '']
      csv << ['Charlie', '555-666-7777', '', 'charlie@example.com', 'charlie.alt@example.com']
      csv << ['David', '', '', 'david@example.com', 'charlie@example.com']
    end
  end

  after do
    File.delete(input_file) if File.exist?(input_file)
    File.delete(output_file) if File.exist?(output_file)
  end

  describe '#group_records' do
    before { grouping_assessment.group_records }

    it 'creates an output file' do
      expect(File.exist?(output_file)).to be true
    end

    it 'adds a Person ID column to the output file' do
      headers = CSV.open(output_file, 'r', &:readline)
      expect(headers).to include('Person ID')
    end

    it 'groups records correctly based on the same phone number' do
      grouped_data = CSV.read(output_file, headers: true)

      alice_group = grouped_data.find { |row| row['Name'] == 'Alice' }['Person ID']
      bob_group = grouped_data.find { |row| row['Name'] == 'Bob' }['Person ID']
      charlie_group = grouped_data.find { |row| row['Name'] == 'Charlie' }['Person ID']
      david_group = grouped_data.find { |row| row['Name'] == 'David' }['Person ID']

      expect(alice_group).to eq(bob_group) # Alice and Bob share the same phone number
      expect(charlie_group).not_to eq(david_group) # Charlie and David do not share a phone
    end
  end

  describe '#grouping_columns' do
    context 'when matching type is same_email' do
      let(:matching_type) { 'same_email' }

      it 'returns only email columns' do
        expect(grouping_assessment.send(:grouping_columns)).to contain_exactly('Email1', 'Email2')
      end
    end

    context 'when matching type is same_phone' do
      it 'returns only phone columns' do
        expect(grouping_assessment.send(:grouping_columns)).to contain_exactly('Phone1', 'Phone2')
      end
    end

    context 'when matching type is same_email_or_phone' do
      let(:matching_type) { 'same_email_or_phone' }

      it 'returns both phone and email columns' do
        expect(grouping_assessment.send(:grouping_columns)).to contain_exactly('Phone1', 'Phone2', 'Email1', 'Email2')
      end
    end
  end
end
