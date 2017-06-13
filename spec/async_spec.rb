describe 'async' do
  subject do
    promise = Promise.new
    delay 1 do
      promise.resolve 42
    end
    promise
  end

  it { is_expected.to be_a Promise }
  it { is_expected.to eq 42 }
end
