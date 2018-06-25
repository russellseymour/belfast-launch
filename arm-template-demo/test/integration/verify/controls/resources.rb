resource_group_name = attribute('resource_group_name', default: 'Belfast-Demo-VSTS', description: 'Name of the resource group to interogate')

title 'Check all resources are present'

control 'Belfast-Demo-Resources' do
  impact 1.0
  title 'Determine that all resources for the Managed Application have been created'

  describe azure_generic_resource(group_name: resource_group_name) do

    # It should have two network interfaces, one for each vm
    its('Microsoft.Network/networkInterfaces') { should eq 1 }

    # It should have two network security groups, one for each server
    its('Microsoft.Network/networkSecurityGroups') { should eq 1 }

    its('Microsoft.Compute/virtualMachines') { should eq 1 }

    # The VMs should each have a disk associated
    its('Microsoft.Compute/disks') { should eq 1 }

  end
end
