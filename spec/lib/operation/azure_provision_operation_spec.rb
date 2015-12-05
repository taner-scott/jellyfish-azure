require 'spec_helper'
require 'jellyfish_azure'

module JellyfishAzure
  module Operation
    describe 'AzureProvisionOperation#execute' do
      let(:cloud_client) do
        OpenStruct.new(
          storage: double,
          deployment: double,
          resource_group: double)
      end

      let(:service) { create :service }
      let(:operation) do
        result = JellyfishAzure::Operation::AzureProvisionOperation.new cloud_client, {}, {}, service

        allow(result).to receive(:setup)
        allow(result).to receive(:template_url).and_return('https://test.com/mytemplate.json')
        allow(result).to receive(:location).and_return('westus')
        allow(result).to receive(:template_parameters).and_return({})

        result
      end

      subject(:service_result) do
        operation.execute
        service
      end

      context 'when deployment successful' do
        before do
          allow(cloud_client.resource_group).to receive(:create_resource_group)
          allow(cloud_client.deployment).to receive(:create_deployment)
          allow(cloud_client.deployment).to receive(:get_deployment_status)
            .and_return(['Succeeded', {}])
        end

        context 'status' do
          it { expect(service_result.status).to eq :available }
          it { expect(service_result.status_msg).to eq 'Deployment successful' }
        end

        context 'service outputs' do
          before do
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_return([
                'Succeeded',
                {
                  output1: { value: 'value1' },
                  output2: { value: 'value2' }
                }])
          end

          subject(:service_outputs) do
            operation.execute
            service.service_outputs.outputs
          end

          it { expect(service_outputs.length).to eq 2 }
          it { expect(service_outputs[0]).to include(name: :output1, value: 'value1', value_type: :string) }
          it { expect(service_outputs[1]).to include(name: :output2, value: 'value2', value_type: :string) }
        end

        context 'request received to' do
          after { service_result }

          it 'create resource group' do
            expect(cloud_client.resource_group).to receive(:create_resource_group)
              .with(operation.resource_group_name, operation.location)
          end

          it 'create deployment' do
            expect(cloud_client.deployment).to receive(:create_deployment)
              .with(operation.resource_group_name, any_args, operation.template_url, {})
          end
        end
      end

      context 'when setup fails' do
        before do
          allow(operation).to receive(:setup).and_raise(ValidationError, 'test failure')
        end

        context 'status' do
          it { expect(service_result.status).to eq :terminated }
          it { expect(service_result.status_msg).to eq 'test failure' }
        end
      end

      context 'when resource group creation fails' do
        context 'due to azure error' do
          before do
            allow(cloud_client.resource_group).to receive(:create_resource_group)
              .and_raise(MsRestAzure::AzureOperationError, 'test failure')
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'test failure' }
          end
        end

        context 'due to unknown error, status' do
          before do
            allow(cloud_client.resource_group).to receive(:create_resource_group)
              .and_raise(StandardError, 'test failure')
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'Unexpected error: StandardError: test failure' }
          end
        end
      end

      context 'when deployment creation fails' do
        before do
          allow(cloud_client.resource_group).to receive(:create_resource_group)
        end

        context 'due to azure error' do
          before do
            allow(cloud_client.deployment).to receive(:create_deployment)
              .and_raise(MsRestAzure::AzureOperationError, 'test failure')
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'test failure' }
          end
        end

        context 'due to unknown error, status' do
          before do
            allow(cloud_client.deployment).to receive(:create_deployment)
              .and_raise(StandardError, 'test failure')
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'Unexpected error: StandardError: test failure' }
          end
        end
      end

      context 'when deployment status check fails' do
        before do
          allow(cloud_client.resource_group).to receive(:create_resource_group)
          allow(cloud_client.deployment).to receive(:create_deployment)
        end

        context 'due to deployment error' do
          before do
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_return(['Failed', {}])

            allow(cloud_client.deployment).to receive(:get_deployment_errors)
              .and_return([
                JellyfishAzure::AzureDeploymentError.new('Deployment failure 1'),
                JellyfishAzure::AzureDeploymentError.new('Deployment failure 2')
              ])
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq "Deployment failure 1\nDeployment failure 2" }
          end
        end

        context 'due to azure error' do
          before do
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_raise(MsRestAzure::AzureOperationError, 'test failure')
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'test failure' }
          end
        end

        context 'due to unknown error, status' do
          before do
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_raise(StandardError, 'test failure')
          end

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'Unexpected error: StandardError: test failure' }
          end
        end
      end

      context 'when deployment times out' do
        before do
          operation.deploy_timeout = 0.2
          operation.deploy_delay = 0.1

          allow(cloud_client.resource_group).to receive(:create_resource_group)
          allow(cloud_client.deployment).to receive(:create_deployment)
          allow(cloud_client.deployment).to receive(:get_deployment_status)
            .and_return(['Running', {}])
        end

        context 'status' do
          it { expect(service_result.status).to eq :terminated }
          it { expect(service_result.status_msg).to eq 'The provisioning operation timed out.' }
        end
      end
    end
  end
end
