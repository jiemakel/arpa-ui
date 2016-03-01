angular.module('app').controller 'ServiceCtrl', ($scope,$http,$stateParams,toastr,services) !->
  $scope.service = $stateParams.service
  $scope.name=$scope.service
  $scope.maxNGrams=3
  $scope.detph=1
  $scope.negativeLASFilters = ''
  $scope.strongNegativeLASFilters = ''
  $scope.positiveLASFilters = ''
  $scope.query='''
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    SELECT ?id ?label ?ngram {
      VALUES ?ngram {
        <VALUES>
      }
      BIND(?ngram AS ?label)
      ?id rdfs:label|skos:prefLabel ?label .
    }
  '''
  $scope.delete = !->
    response <-! $http.delete(services+$scope.service).then(_,$scope.handleError)
    toastr.success("Successfully removed service #{$scope.service} (#{$scope.name})")
  $scope.submit = !->
    map = {}
    for kv in $scope.positiveLASFilters.split(/, ?/)
      [k,v] = kv.split(':')
      map.[][k].push(v)
    positiveLASFilters = map
    map = {}
    for kv in $scope.negativeLASFilters.split(/, ?/)
      [k,v] = kv.split(':')
      map.[][k].push(v)
    negativeLASFilters = map
    map = {}
    for kv in $scope.strongNegativeLASFilters.split(/, ?/)
      [k,v] = kv.split(':')
      map.[][k].push(v)
    strongNegativeLASFilters = map
    response <-! $http.put(services+$scope.service,{
      $scope.name
      $scope.endpointURL
      $scope.lasLocale
      $scope.queryUsingOriginalForm
      $scope.queryUsingBaseform
      queryUsingInflections: if (typeof $scope.queryUsingInflections == 'string') then $scope.queryUsingInflections.split(/, ?/) else $scope.queryUsingInflections
      $scope.queryModifyingEveryPart
      $scope.queryModifyingOnlyLastPart
      positiveLASFilters
      negativeLASFilters
      strongNegativeLASFilters
      $scope.guess
      $scope.query
      depth:parseInt($scope.depth)
      maxNGrams:parseInt($scope.maxNGrams)
    }).then(_,$scope.handleError)
    toastr.success("Successfully saved service #{$scope.service} (#{$scope.name})")
  $scope.loading = true
  response <-! $http.get(services+$scope.service).then(_,(response) !-> if response.status!=404 then $scope.handleError(response) else $scope.loading=false)
  $scope.loading=false
  for item,value of response.data
    if (item=='negativeLASFilters')
      if (value)
        for k,va of value
          for v in va
            $scope.negativeLASFilters += k+':'+v+', '
        $scope.negativeLASFilters = $scope.negativeLASFilters.substring(0,$scope.negativeLASFilters.length-2)
    else if (item=='strongNegativeLASFilters')
      if (value)
        for k,va of value
          for v in va
            $scope.strongNegativeLASFilters += k+':'+v+', '
        $scope.strongNegativeLASFilters = $scope.strongNegativeLASFilters.substring(0,$scope.strongNegativeLASFilters.length-2)
    else if (item=='positiveLASFilters')
      if (value)
        for k,va of value
          for v in va
            $scope.positiveLASFilters += k+':'+v+', '
        $scope.positiveLASFilters = $scope.positiveLASFilters.substring(0,$scope.positiveLASFilters.length-2)
    else $scope[item]=value
