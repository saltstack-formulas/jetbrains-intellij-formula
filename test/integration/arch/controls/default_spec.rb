# frozen_string_literal: true

title 'intellij archives profile'

control 'intellij archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/intellij.sh') do
    it { should exist }
  end
  # describe file('/usr/local/jetbrains/intellij-C-*/bin/idea.sh') do
  #    it { should exist }
  # end
  describe file('/usr/share/applications/intellij.desktop') do
    it { should exist }
  end
end
