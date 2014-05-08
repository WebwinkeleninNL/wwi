manageControllers.controller('MerchantsController', ['$scope', 'Merchant', function($scope, Merchant){
  $scope.searching = true;

  Merchant.query().then(function (results) {
    $scope.merchants = results;
    $scope.searching = false;
  }, function (error) {
    $scope.searching = false;
  });

  $scope.addMerchant = function(){
    new Merchant($scope.newMerchant).create().then(function(){
      $scope.merchants.unshift($scope.newMerchant);
    }, function(err){
      alert(err)
    });
  }
}]);
