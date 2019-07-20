# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'instances_method' do
    context 'when filterable' do
      it 'responds to filter' do
        expect(Contact).to respond_to(:filter)
      end

      it 'responds to apply_filter' do
        expect(Contact).to respond_to(:apply_filter)
      end
    end

    context 'when sortable' do
      it 'responds to apply_sort' do
        expect(Contact).to respond_to(:apply_sort)
      end

      it 'responds to sortable_fields' do
        expect(Contact).to respond_to(:sortable_fields)
      end

      it 'responds to default_sort' do
        expect(Contact).to respond_to(:default_sort)
      end
    end
  end

  describe '#apply_filter' do
    let!(:anakin) { create(:contact, first_name: 'Anakin', last_name: 'Skywalker') }
    let!(:harry) { create(:contact, first_name: 'Harry', last_name: 'Potter') }
    let!(:peter) { create(:contact, first_name: 'Peter', last_name: 'Parker') }

    context 'with valid params' do
      let(:valid_params) do
        {
          filter: { first_name: 'Anakin' }
        }
      end

      it 'filters by first_name' do
        expect(Contact.apply_filter(valid_params)).to include(anakin)
        expect(Contact.apply_filter(valid_params)).to_not include(harry)
      end

      it 'filters by multiple first_name' do
        valid_params = {
          filter: { first_name: 'Anakin,Harry' }
        }

        expect(Contact.apply_filter(valid_params)).to include(anakin, harry)
        expect(Contact.apply_filter(valid_params)).to_not include(peter)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          filter: { last_name: 'Potter' }
        }
      end

      it 'does not filter by last_name' do
        expect(Contact.apply_filter(invalid_params)).to include(anakin, harry)
      end
    end
  end

  describe '#apply_sort' do
    let!(:anakin) { create(:contact, first_name: 'Anakin', last_name: 'Skywalker') }
    let!(:harry) { create(:contact, first_name: 'Harry', last_name: 'Potter') }

    context 'with valid params' do
      it 'sorts by last_name' do
        valid_params = { sort: 'last_name' }
        expected_ids = Contact.order(:last_name).pluck(:id)
        not_expected_ids = Contact.order(last_name: :desc).pluck(:id)

        expect(Contact.apply_sort(valid_params).pluck(:id)).to eq(expected_ids)
        expect(Contact.apply_sort(valid_params).pluck(:id)).to_not eq(not_expected_ids)
      end

      it 'sorts by last_name desc' do
        valid_params = { sort: '-last_name' }
        expected_ids = Contact.order(last_name: :desc).pluck(:id)
        not_expected_ids = Contact.order(:last_name).pluck(:id)

        expect(Contact.apply_sort(valid_params).pluck(:id)).to eq(expected_ids)
        expect(Contact.apply_sort(valid_params).pluck(:id)).to_not eq(not_expected_ids)
      end

      it 'sorts by allowed fields only' do
        valid_params = { sort: 'last_name' } # must be ignored
        expected_ids = Contact.order(last_name: :desc).pluck(:id) # default sort
        not_expected_ids = Contact.order(:last_name).pluck(:id) # params sort

        expect(Contact.apply_sort(valid_params, allowed: [:first_name, :age]).pluck(:id)).to eq(expected_ids)
        expect(Contact.apply_sort(valid_params, allowed: [:first_name, :age]).pluck(:id)).to_not eq(not_expected_ids)
      end
    end

    context 'with invalid params' do
      let(:anakin) { create(:contact, first_name: 'Anakin', last_name: 'Skywalker', age: 19) }
      let(:harry) { create(:contact, first_name: 'Harry', last_name: 'Potter', age: 13) }

      it 'does not sort by age' do
        invalid_params = { sort: 'age' }
        expected_ids = Contact.pluck(:id)
        not_expected_ids = Contact.order(:age).pluck(:id)

        expect(Contact.apply_sort(invalid_params).pluck(:id)).to eq(expected_ids)
        expect(Contact.apply_sort(invalid_params).pluck(:id)).to_not eq(not_expected_ids)
      end
    end
  end

  describe '#default_sort' do
    let!(:anakin) { create(:contact, first_name: 'Anakin', last_name: 'Skywalker') }
    let!(:harry) { create(:contact, first_name: 'Harry', last_name: 'Potter') }
    let!(:spiderman) { create(:contact, first_name: 'Peter', last_name: 'Parker') }

    it 'sorts by default params' do
      expected_ids = Contact.order(last_name: :desc).pluck(:id)
      not_expected_ids = Contact.order(:last_name).pluck(:id)

      expect(Contact.apply_sort.pluck(:id)).to eq(expected_ids)
      expect(Contact.apply_sort.pluck(:id)).to_not eq(not_expected_ids)
    end
  end
end
