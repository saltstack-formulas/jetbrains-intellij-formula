# frozen_string_literal: true

title 'intellij archives profile'

control 'intellij archive' do
  impact 1.0
  title 'should be installed'

  describe file('/usr/local/intellij-C-2020.1') do
    it { should exist }
  end
end
