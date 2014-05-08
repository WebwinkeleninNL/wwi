//= require bootstrap.min

//= require ng-rails-csrf
//= require angularjs/rails/resource

var manageApp = angular.module('manageApp', ['ngRoute', 'ngResource', 'manageControllers', 'ng-rails-csrf', 'rails']);

var manageControllers = angular.module('manageControllers', []);

manageApp.config(function($routeProvider) {
  $routeProvider
    .when('/',
      {
        controller: 'MerchantsController',
        templateUrl: '/manage/merchants'
      })
    .when('/merchant/:merchantId',
      {
        controller: 'MerchantDetailsController',
        templateUrl: '/manage/merchant'
      })
    .otherwise({redirectTo: '/'})
});


manageApp.factory('Merchant', ['railsResourceFactory', 'railsSerializer', function (railsResourceFactory, railsSerializer) {
    return railsResourceFactory({
        url: '/admin/merchants',
        name: 'merchant',
        serializer: railsSerializer(function () {
          this.exclude('id');
        })
    });
}]);