manageControllers.controller('MerchantDetailsController', ['$scope', '$routeParams', 'Merchant', function($scope, $routeParams, Merchant){
  Merchant.get($routeParams.merchantId).then(function(merchant){
    $scope.merchant = merchant;
  })

  $scope.updateMerchant = function(){
    $scope.merchant.update().then(function(){ alert("Saved!") }, function(){ alert('Error')});
  }
}]);
