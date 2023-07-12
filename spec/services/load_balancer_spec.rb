require 'rails_helper'

RSpec.describe SmsProvider do
    let(:light) { 'provider1' }
    let(:heavy) { 'provider2' }

    describe 'check_load' do
        context 'when there are three or more requests counted' do
            it 'maintains an approximated ratio of 30/70 between the specified light and heavy providers' do
                10.times { LoadBalancer.check_load(light_load: light, heavy_load: heavy) }

                expect($redis.get(light)).to eq '3'
                expect($redis.get(heavy)).to eq '7'
            end
        end
    end

    describe 'reset_providers' do
        before do
            $redis.set(light, 5)
            $redis.set(heavy, 5)
        end

        it 'resets the provider keys' do
            LoadBalancer.reset_providers
            expect($redis.get(light)).to eq '0'
            expect($redis.get(heavy)).to eq '0'
        end
    end
end