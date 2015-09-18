(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    /*
    Forms.fields('azure_regions', {
      type: 'select',
      templateOptions: {
        label: 'Region',
        options: [
          {label: 'N. Virginia (US-East-1)', value: 'us-east-1', group: 'US'},
          {label: 'N. California (US-West-1)', value: 'us-west-1', group: 'US'},
          {label: 'Oregon (US-West-2)', value: 'us-west-2', group: 'US'},
          {label: 'Ireland (EU-West-1)', value: 'eu-west-1', group: 'Europe'},
          {label: 'Frankfurt (EU-Central-1)', value: 'eu-central-1', group: 'Europe'},
          {label: 'Singapore (AP-Southeast-1)', value: 'ap-southeast-1', group: 'Asia Pacific'},
          {label: 'Sydney (AP-Southeast-2)', value: 'ap-southeast-2', group: 'Asia Pacific'},
          {label: 'Tokyo (AP-Northeast-1)', value: 'ap-northeast-1', group: 'Asia Pacific'},
          {label: 'Sãn Paulo (SA-East-1)', value: 'sa-east-1', group: 'South America'}
        ]
      }
    });
*/

    Forms.fields('azure_storage_name', {
      type: 'text',
      templateOptions: {
        label: 'Name'
      }
    });

    Forms.fields('azure_resource_group_name', {
      type: 'text',
      templateOptions: {
        label: 'Resource Group'
      }
    });

    Forms.fields('azure_location', {
      type: 'async_select',
      templateOptions: {
        label: 'Location',
        options: []
      },
      data: {
        action: 'azure_locations'
      },
      controller: AzureDataController
    });

    Forms.fields('azure_storage_accountType', {
      type: 'select',
      templateOptions: {
        label: 'Type',
        options: [
          {label: 'Standard LRS', value: 'Standard_LRS'},
          {label: 'Standard ZRS', value: 'Standard_ZRS'},
          {label: 'Standard GRS', value: 'Standard_GRS'},
          {label: 'Standard RAGRS', value: 'Standard_RAGRS'},
          {label: 'Premium LRS', value: 'Premium_LRS'}
        ]
      }
    });

    /** @ngInject */
    function AzureDataController($scope, AzureData, Toasts) {
      var provider = $scope.formState.provider;
      var action = $scope.options.data.action;

      // Cannot do anything without a provider
      if (angular.isUndefined(provider)) {
        Toasts.warning('No provider set in form state', $scope.options.label);
        return;
      }

      if (!action) {
        Toasts.warning('No action set in field data', $scope.options.label);
        return;
      }

      $scope.to.loading = AzureData[action](provider.id).then(handleResults, handleError);

      function handleResults(data) {
        $scope.to.options = data;
        return data;
      }


      function handleError(response) {
        var error = response.data;

        if (!error.error) {
          error = {
            type: 'Server Error',
            error: 'An unknown server error has occurred.'
          };
        }

        Toasts.error(error.error, [$scope.to.label, error.type].join('::'));

        return response;
      }
    }
  }
})();
