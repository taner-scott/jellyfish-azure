module JellyfishAzure
  RSpec.describe 'Jellyfish Azure Test Spec', type: :request do
    it 'simple test to verify tests can execute', type: :request do
	  item = 'onew'
      expect(item).to eq('one')
    end
  end
end
