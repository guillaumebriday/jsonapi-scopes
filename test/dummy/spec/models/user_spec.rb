# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'instances_method' do
    it 'responds to apply_sort' do
      expect(User).to respond_to(:apply_include)
    end

    it 'responds to allowed_includes' do
      expect(User).to respond_to(:allowed_includes)
    end
  end

  describe '#apply_include' do
    let!(:contact) { create(:contact) }
    let!(:user) { create(:user, contact: contact) }
    let!(:posts) { create_list(:post, 3, user: user) }

    context 'with valid params' do
      let(:valid_params) do
        {
          include: 'contact,posts'
        }
      end

      it 'includes relationships' do
        users = User.apply_include(valid_params)
        expect(users.first.association(:contact)).to be_loaded
        expect(users.first.association(:posts)).to be_loaded
      end

      it 'includes sub relationships' do
        valid_params = {
          include: 'contact,posts.contact.users,posts.user'
        }

        users = User.apply_include(valid_params)
        expect(users.first.association(:contact)).to be_loaded
        expect(users.first.posts.first.association(:contact)).to be_loaded
        expect(users.first.posts.first.association(:user)).to be_loaded
        expect(users.first.posts.first.contact.association(:users)).to be_loaded
      end
    end

    context 'with custom allowed attributes' do
      let(:valid_params) do
        {
          include: 'posts.contact'
        }
      end

      it 'raises an error' do
        expect { User.apply_include(valid_params) }.to raise_exception(Jsonapi::InvalidAttributeError, 'posts.contact is not valid as include attribute.')
      end

      it 'includes sub relationships' do
        users = User.apply_include(valid_params, allowed: 'posts.contact')
        expect(users.first.posts.first.association(:contact)).to be_loaded
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          include: 'invalid'
        }
      end

      it 'raises an exception' do
        expect { User.apply_include(invalid_params) }.to raise_exception(Jsonapi::InvalidAttributeError, 'invalid is not valid as include attribute.')
      end
    end

    context 'with empty params' do
      let(:empty_params) do
        {
          include: ''
        }
      end

      it 'returns same collection' do
        expect(User.apply_include(empty_params).first).to eq(User.first)
      end
    end
  end

  describe '#convert_includes_as_hash' do
    it 'returns the correct hash' do
      expect(User.send(:convert_includes_as_hash, 'contact')).to eq(contact: {})
      expect(User.send(:convert_includes_as_hash, 'contact,posts')).to eq(contact: {}, posts: {})
      expect(User.send(:convert_includes_as_hash, 'contact,posts.user')).to eq(contact: {}, posts: { user: {} })
      expect(User.send(:convert_includes_as_hash, 'contact,posts.user,posts.contact')).to eq(contact: {}, posts: { user: {}, contact: {} })
      expect(User.send(:convert_includes_as_hash, 'contact,posts.user,posts.contact.users')).to eq(contact: {}, posts: { user: {}, contact: { users: {} } })
      expect(User.send(:convert_includes_as_hash, 'contact,posts.user,posts.contact.users,contact.users')).to eq(contact: { users: {} }, posts: { user: {}, contact: { users: {} } })
      expect(User.send(:convert_includes_as_hash, 'contact,posts.user,posts.contact,posts.user.contacts')).to eq(contact: {}, posts: { user: { contacts: {} }, contact: {} })
      expect(User.send(:convert_includes_as_hash, '')).to eq({})
    end
  end
end
