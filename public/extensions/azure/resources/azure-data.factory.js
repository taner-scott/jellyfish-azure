(function() {
  'use strict';

  angular.module('app.resources')
    .factory('AzureProductData', AzureProductData)
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
  function AzureProductData($resource) {
	  var base = '/api/v1/azure/products/:id/:action';
	  var resource = $resource(base, {action: '@action', id: '@id' });

	  resource.locations = function (id) {
		  return resource.query({id: id, action: 'locations'}).$promise;
	  };

	  return resource;
  }
})();
