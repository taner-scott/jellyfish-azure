require 'spec_helper'

require_relative '../../../lib/jellyfish_azure.rb'

module JellyfishAzure
  module Operation
    describe 'AzureOperation#execute' do
      let (:service) { create :service }

      let (:cloud_client) {
        double('cloud_client',
          deployment: double('resource_group_client'),
          resource_group: double('deployment_client'))
      }

      let (:operation) {
        result = JellyfishAzure::Operation::AzureOperation.new cloud_client, {}, {}, service

        allow(result).to receive(:setup)
        allow(result).to receive(:template_url).and_return('https://test.com/mytemplate.json')
        allow(result).to receive(:location).and_return('westus')
        allow(result).to receive(:template_parameters).and_return({})

        result
      }

      subject(:service_result) {
        operation.execute
        service
      }

      context 'when deployment successful' do
        before {
          allow(cloud_client.resource_group).to receive(:create_resource_group)
          allow(cloud_client.deployment).to receive(:create_deployment)
          allow(cloud_client.deployment).to receive(:get_deployment_status)
            .and_return(['Succeeded', {}])
        }

        context 'status' do
          it { expect(service_result.status).to eq :available }
          it { expect(service_result.status_msg).to eq 'Deployment successful' }
        end

        context 'service outputs' do
          before {
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_return(['Succeeded', {
                output1: { value: 'value1' },
                output2: { value: 'value2' }
              }])
          }

          subject(:service_outputs) {
            operation.execute
            service.service_outputs.outputs
          }

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
        before {
          allow(operation).to receive(:setup).and_raise(ValidationError, 'test failure')
        }

        context 'status' do
          it { expect(service_result.status).to eq :terminated }
          it { expect(service_result.status_msg).to eq 'Validation error: test failure' }
        end
      end

      context 'when resource group creation fails' do
        context 'due to azure error' do
          before {
            allow(cloud_client.resource_group).to receive(:create_resource_group)
              .and_raise(MsRestAzure::AzureOperationError, 'test failure')
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'test failure' }
          end
        end

        context 'due to unknown error, status' do
          before {
            allow(cloud_client.resource_group).to receive(:create_resource_group)
              .and_raise(StandardError, 'test failure')
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'Unexpected error: StandardError: test failure' }
          end
        end
      end

      context 'when deployment creation fails' do
        before {
          allow(cloud_client.resource_group).to receive(:create_resource_group)
        }

        context 'due to azure error' do
          before {
            allow(cloud_client.deployment).to receive(:create_deployment)
              .and_raise(MsRestAzure::AzureOperationError, 'test failure')
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'test failure' }
          end
        end

        context 'due to unknown error, status' do
          before {
            allow(cloud_client.deployment).to receive(:create_deployment)
              .and_raise(StandardError, 'test failure')
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'Unexpected error: StandardError: test failure' }
          end
        end
      end

      context 'when deployment status check fails' do
        before {
          allow(cloud_client.resource_group).to receive(:create_resource_group)
          allow(cloud_client.deployment).to receive(:create_deployment)
        }

        context 'due to deployment error' do
          before {
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_return(['Failed', {}])

            allow(cloud_client.deployment).to receive(:get_deployment_errors)
              .and_return([
                JellyfishAzure::Operation::AzureDeploymentError.new('Deployment failure 1'),
                JellyfishAzure::Operation::AzureDeploymentError.new('Deployment failure 2')
              ])
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq "Deployment failure 1\nDeployment failure 2"}
          end
        end

        context 'due to azure error' do
          before {
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_raise(MsRestAzure::AzureOperationError, 'test failure')
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'test failure' }
          end
        end

        context 'due to unknown error, status' do
          before {
            allow(cloud_client.deployment).to receive(:get_deployment_status)
              .and_raise(StandardError, 'test failure')
          }

          context 'status' do
            it { expect(service_result.status).to eq :terminated }
            it { expect(service_result.status_msg).to eq 'Unexpected error: StandardError: test failure' }
          end
        end
      end

      context 'when deployment times out' do
        before {
          operation.deploy_timeout = 0.2
          operation.deploy_delay = 0.1

          allow(cloud_client.resource_group).to receive(:create_resource_group)
          allow(cloud_client.deployment).to receive(:create_deployment)
          allow(cloud_client.deployment).to receive(:get_deployment_status)
            .and_return(['Running', {}])
        }

        context 'status' do
          it { expect(service_result.status).to eq :terminated }
          it { expect(service_result.status_msg).to eq 'The provisioning operation timed out.' }
        end
      end
    end
  end
end
