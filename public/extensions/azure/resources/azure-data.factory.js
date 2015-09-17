(function() {
  'use strict';

  angular.module('app.resources')
    .factory('AzureData', AzureDataFactory);

  /** @ngInject */
  function AzureDataFactory($resource) {
    var base = '/api/v1/azure/providers/:id/:action';
    var AzureData = $resource(base, {action: '@action', id: '@id'});

    AzureData.azureLocations = azureLocations;

    return AwsData;

    function azureLocations(id) {
      return AwsData.query({id: id, action: 'azureLocations'}).$promise;
    }
  }
})();
