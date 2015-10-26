(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    Forms.fields('az_dev_web', {
      type: 'select',
      templateOptions: {
        options: [
          {label: 'NodeJS', value: 'nodejs'},
          {label: 'Ruby', value: 'ruby'}
        ]
      }
    });

    Forms.fields('az_dev_db', {
      type: 'select',
      templateOptions: {
        options: [
          {label: 'Postgres', value: 'postgres'}
        ]
      }
    });

    Forms.fields('az_custom_location', {
      type: 'select',
      templateOptions: {
        options: []
      },
      data: {
        action: 'web_dev_locations'
      },
      controller: AzureDataController
    });
    Forms.fields('az_dev_location', {
      type: 'select',
      templateOptions: {
        options: []
      },
      data: {
        action: 'web_dev_locations'
      },
      controller: AzureDataController
    });

    Forms.fields('azure_storage_name', {
      type: 'text',
      templateOptions: {
        label: 'Name'
      }
    });

    Forms.fields('azure_resource_group_name', {
      type: 'async_select',
      templateOptions: {
        label: 'Resource Group',
        options: []
      },
      data: {
        action: 'azure_resource_groups'
      },
      controller: AzureDataController
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
