(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    Forms.fields('az_choice', {
      type: 'select',
      templateOptions: {
        options: []
      },
      data: {
        action: 'values'
      },
      controller: AzureProductFieldDataController
    });

    Forms.fields('az_location', {
      type: 'select',
      templateOptions: {
        options: []
      },
      data: {
        action: 'locations'
      },
      controller: AzureProductDataController
    });

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
    function AzureProductDataController($scope, AzureProductData, Toasts) {
      var product = $scope.formState.product;
      var action = $scope.options.data.action;

      // Cannot do anything without a product
      if (angular.isUndefined(product)) {
        Toasts.warning('No product set in form state', $scope.options.label);
        return;
      }

      if (!action) {
        Toasts.warning('No action set in field data', $scope.options.label);
        return;
      }

      $scope.to.loading = AzureProductData[action](product.id).then(handleResults, handleError);

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

    /** @ngInject */
    function AzureProductFieldDataController($scope, AzureProductFieldData, Toasts) {
      var product = $scope.formState.product;
	    var field = $scope.options.model.name;

      var action = $scope.options.data.action;

      // Cannot do anything without a product
      if (angular.isUndefined(product)) {
        Toasts.warning('No product set in form state', $scope.options.label);
        return;
      }

      // Cannot do anything without a field
      if (angular.isUndefined(field)) {
        Toasts.warning('No field set in form state', $scope.options.label);
        return;
      }

      if (!action) {
        Toasts.warning('No action set in field data', $scope.options.label);
        return;
      }

      $scope.to.loading = AzureProductFieldData[action](product.id, $scope.options.model.name).then(handleResults, handleError);

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
