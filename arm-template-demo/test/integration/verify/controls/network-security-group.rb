resource_group_name = attribute('resource_group_name', default: 'Belfast-Demo-VSTS', description: 'Name of the resource group to interogate')
location = attribute('location', default: 'westeurope')
ssh_source_addresses = attribute('ssh_source_addresses', default: ['*'])

# Define array that states where the traffic is coming from
# Both denote access from the Internet
sources = ['*', 'Internet']

title 'Ensure that all Network Security Groups are setup correctly'

control 'Automate-Server-NSG' do
  impact 1.0
  title 'Check the settings of the network security group for the Automate server'

  describe azure_generic_resource(group_name: resource_group_name, name: 'belfast-demo-nsg') do
    its('type') { should eq 'Microsoft.Network/networkSecurityGroups' }
    its('location') { should cmp location }
    its('properties.provisioningState') { should cmp 'Succeeded' }
    its('properties.securityRules.count') { should cmp 3 }

    # it should be connected to the correct NIC
    its('properties.networkInterfaces.first.id') { should include "belfast-demo-vm-nic" }
  end
end

control 'Belfast-Demo-NSG-Port-80' do
  impact 1.0
  title 'Ensure that port 80 (HTTP) is accessible from the Internet'

  # Perform specifc test to check that port 80 is open
  port_80_rule = azure_generic_resource(group_name: resource_group_name, name: "belfast-demo-nsg")
                 .properties.securityRules.find { |r| r.properties.destinationPortRange == '80' && sources.include?(r.properties.sourceAddressPrefix) }

  describe port_80_rule do
    it 'rule should exist' do
      expect(subject).not_to be_nil
    end
  end
end

control 'Belfast-Demo-NSG-Port-443' do
  impact 1.0
  title 'Ensure that port 443 (HTTPS) is accessible from the Internet'

  # Perform specifc test to check that port 443 is open
  port_443_rule = azure_generic_resource(group_name: resource_group_name, name: "belfast-demo-nsg")
                  .properties.securityRules.find { |r| r.properties.destinationPortRange == '443' && sources.include?(r.properties.sourceAddressPrefix) }

  describe port_443_rule do
    it 'rule should exist' do
      expect(subject).not_to be_nil
    end
  end
end

control 'Belfast-Demo-NSG-Port-22' do
  impact 1.0
  title 'Ensure that port 22 (SSH) is not accessible from the Internet'

  # Perform specifc test to check that port 22 is open
  port_22_rule = azure_generic_resource(group_name: resource_group_name, name: "belfast-demo-nsg")
                 .properties.securityRules.find { |r| r.properties.destinationPortRange == '22' && sources.include?(r.properties.sourceAddressPrefix) }

  describe port_22_rule do
    it 'rule should not exist' do
      expect(subject).to be_nil
    end
  end
end
