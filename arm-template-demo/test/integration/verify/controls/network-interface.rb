resource_group_name = attribute('resource_group_name', default: 'Belfast-Demo-VSTS', description: 'Name of the resource group to interogate')
location = attribute('location', default: 'westeurope')
customer_subnet_name = attribute('customer_subnet_name', default: 'belfast-demo-subnet')

title 'Check that all Network Interface Cards are setup correctly'

control 'Belfast-Demo-NIC' do
  impact 1.0
  title 'Ensure that the NIC connected to the Customer VNet is configured correctly'

  describe azure_generic_resource(group_name: resource_group_name, name: 'belfast-demo-vm-nic') do
    its('type') { should eq 'Microsoft.Network/networkInterfaces' }
    its('location') { should cmp location }
    its('properties.provisioningState') { should cmp 'Succeeded' }
    its('properties.ipConfigurations.first.properties.provisioningState') { should cmp 'Succeeded' }
    its('properties.ipConfigurations.first.properties.privateIPAllocationMethod') { should cmp 'Dynamic' }
    its('properties.ipConfigurations.first.properties.subnet.id') { should include customer_subnet_name }
    its('properties.ipConfigurations.first.properties.primary') { should be true }
    its('properties.ipConfigurations.first.properties.privateIPAddressVersion') { should cmp 'IPv4' }

    its('properties.dnsSettings.dnsServers.count') { should be 0 }
    its('properties.dnsSettings.appliedDnsServers.count') { should be 0 }

    its('properties.enableAcceleratedNetworking') { should be false }
    its('properties.enableIPForwarding') { should be false }

    # Ensure it is connected to the correct network security group
    its('properties.networkSecurityGroup.id') { should include "belfast-demo-nsg" }
  end
end

