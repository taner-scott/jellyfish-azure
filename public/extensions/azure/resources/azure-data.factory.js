(function() {
  'use strict';

  angular.module('app.resources')
    .factory('AzureData', AzureDataFactory)
    .factory('AzureProductFieldData', AzureProductFieldData);

  /** @ngInject */
  function AzureProductFieldData($resource) {
	  var base = '/api/v1/azure/products/:id/:action/:field';
	  var resource = $resource(base, {action: '@action', id: '@id', parameter: '@parameter' });

	  resource.values = function (id, parameter) {
		  return resource.query({id: id, action: 'values', field: parameter}).$promise
		  	.then(function (results) {
          return $.map(results, function (result) {
            return { label: result, value: result	};
          });
        });
	  };

	  return resource;
  }

  /** @ngInject */
  function AzureDataFactory($resource) {
    var base = '/api/v1/azure/providers/:id/:action';
    var AzureData = $resource(base, {action: '@action', id: '@id'});

    AzureData.web_dev_locations = webDevLocations;
    AzureData.azure_locations = azureLocations;
    AzureData.azure_resource_groups = azureResourceGroups;

    return AzureData;

    function webDevLocations(id) {
      return AzureData.query({id: id, action: 'web_dev_locations'}).$promise;
    }

    function azureLocations(id) {
      return AzureData.query({id: id, action: 'azure_locations'}).$promise;
    }

    function azureResourceGroups(id) {
      return AzureData.query({id: id, action: 'azure_resource_groups'}).$promise;
    }
  }
})();
