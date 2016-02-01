angular
.module('app', [])
.controller('controller', function($scope) {
	$scope.type = 'numbers';
	$scope.quantity = 3;
	$scope.minimum = 1;
	$scope.maximum = 10;
	$scope.result = [];

	$scope.inputs = ['bondage', 'discipline', 'dominance', 'submission', 'sadism', 'masochism'];
	$scope.checkBlank = function() {
		if($scope.inputs[$scope.inputs.length - 1]) {
			$scope.inputs.push('');
		}
	};
	$scope.delete = function(index) {
		$scope.inputs.splice(index, 1);
	}

	$scope.main = function() {
		if($scope.quantity <= 0
			|| parseInt($scope.quantity) != $scope.quantity
		) return alert('Error: illegal quantity');

		var copy = [];
		if($scope.type == 'numbers') {
			if($scope.maximum < $scope.minimum)
				return alert('Error: illegal range');
			if($scope.maximum - $scope.minimum + 1 < $scope.quantity)
				return alert('Error: range smaller than quantity');
			for(var i = $scope.minimum; i <= $scope.maximum; ++i) copy.push(i);
		}
		else if($scope.type == 'inputs') {
			if($scope.inputs.length - 1 < $scope.quantity)
				return alert('Error: too few options');
			copy = $scope.inputs.map(function(v){return v;});
			copy.pop();
		}
		else throw new TypeError('Unknown type ' + $scope.type);

		// @see http://stackoverflow.com/questions/2450954/#2450976
		for(var i = 0; i < $scope.quantity; ++i) {
			var rand = i + Math.floor(Math.random() * (copy.length - i));
			var tmp = copy[i];
			copy[i] = copy[rand];
			copy[rand] = tmp;
		}
		$scope.result = copy.slice(0, $scope.quantity);
	}

	$scope.checkBlank();
});
