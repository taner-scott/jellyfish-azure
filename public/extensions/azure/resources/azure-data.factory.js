(function() {
  'use strict';

  angular.module('app.resources')
    .factory('AzureData', AzureDataFactory);

  /** @ngInject */
  function AzureDataFactory($resource) {
    var base = '/api/v1/azure/providers/:id/:action';
    var AzureData = $resource(base, {action: '@action', id: '@id'});

    AzureData.azure_locations = azureLocations;
    AzureData.azure_resource_groups = azureResourceGroups;

    return AzureData;

    function azureLocations(id) {
      return AzureData.query({id: id, action: 'azure_locations'}).$promise;
    }

    function azureResourceGroups(id) {
      return AzureData.query({id: id, action: 'azure_resource_groups'}).$promise;
    }
  }
})();
