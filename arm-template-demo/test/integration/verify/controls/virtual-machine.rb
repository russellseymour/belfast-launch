resource_group_name = attribute('resource_group_name', default: 'Belfast-Demo-VSTS', description: 'Name of the resource group to interogate')
location = attribute('location', default: 'westeurope')

title 'Belfast Demo Virtual Machine'

control 'Belfast Demo VM' do
    impact 1.0
    title 'Check the attributes of the Belfast demo vm'

    describe azure_virtual_machine(group_name: resource_group_name, name: 'belfast-demo-vm') do
        its('type') { should eq 'Microsoft.Compute/virtualMachines' }
        its('location') { should cmp location }

        # Ensure that the machine is from an Ubuntu image
        its('publisher') { should cmp 'canonical' }
        its('offer') { should cmp 'ubuntuserver' }
        its('sku') { should cmp '16.04-LTS' }

        # There should be no data disk attached to the machine
        its('data_disk_count') { should eq 0 }

        # The template sets authentication using an SSK key so password authentication should 
        # be disabled
        it { should_not have_password_authentication }
        it { should have_ssh_keys }
        its('ssh_key_count') { should > 0 }

        # There should be 2 nics attached to the machine
        # these should be one for the AMA network and one for the customer
        it { should have_nics }
        its('nic_count') { should eq 1 }
        its('connected_nics') { should include /belfast-demo-vm-nic/ }

        # Ensure that boot diagnostics have been enabled
        it { should_not have_boot_diagnostics }

        # ensure the OSDisk is setup correctly
        its('os_type') { should eq 'Linux' }
        its('os_disk_name') { should eq 'belfast-demo-os-disk' }
        it { should have_managed_osdisk }
        its('create_option') { should eq 'FromImage' }
    end
end
