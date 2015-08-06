require 'rails_helper'

RSpec.describe Car, :type => :model do
  it { should validate_presence_of :make }
  it { should validate_presence_of :model }
  it { should validate_presence_of :year }
  it { should validate_presence_of :price }
  it { should validate_numericality_of :price }

  it { should validate_numericality_of(:price).is_less_than(1_000_000).is_greater_than(0.00) }
  it { should validate_inclusion_of(:year).in_range(1769..Time.zone.now.year) }

  it { should belong_to(:user) }

  describe ".unclaimed" do
    let!(:claimed_car) {
      FactoryGirl.create(:car, user: FactoryGirl.create(:user))
    }
    let!(:unclaimed_car) { FactoryGirl.create(:car) }

    it 'returns unclaimed cars' do
      expect(Car.unclaimed).to include(unclaimed_car)
    end

    it 'does not return claimed cars' do
      expect(Car.unclaimed).to_not include(claimed_car)
    end
  end
end
