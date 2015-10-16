angular.module('app').controller 'ServiceCtrl', ($scope,$http,$stateParams,toastr,services) !->
  $scope.service = $stateParams.service
  $scope.name=$scope.service
  $scope.maxNGrams=3
  $scope.query='''
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    SELECT ?id ?label ?ngram {
      VALUES ?ngram {
        <VALUES>
      }
      ?id rdfs:label|skos:prefLabel ?ngram .
    }
  '''
  $scope.delete = !->
    response <-! $http.delete(services+$scope.service).then(_,$scope.handleError)
    toastr.success("Successfully removed service #{$scope.service} (#{$scope.name})")
  $scope.submit = !->
    response <-! $http.put(services+$scope.service,{
      $scope.name
      $scope.endpointURL
      $scope.lasLocale
      $scope.queryUsingOriginalForm
      $scope.queryUsingBaseform
      queryUsingInflections: if (typeof $scope.queryUsingInflections == 'string') then $scope.queryUsingInflections.split(/, ?/) else $scope.queryUsingInflections
      $scope.queryModifyingEveryPart
      $scope.queryModifyingOnlyLastPart
      lasFilters: if (typeof $scope.lasFilters == 'string')
        map = {}
        for kv in $scope.lasFilters.split(/, ?/)
          [k,v] = kv.split(':')
          map.[][k].push(v)
        map
      else $scope.lasFilters
      $scope.query
      maxNGrams:parseInt($scope.maxNGrams)
    }).then(_,$scope.handleError)
    toastr.success("Successfully saved service #{$scope.service} (#{$scope.name})")
  $scope.loading = true
  response <-! $http.get(services+$scope.service).then(_,(response) !-> if response.status!=404 then $scope.handleError(response) else $scope.loading=false)
  $scope.loading=false
  for item,value of response.data
    $scope[item]=value
