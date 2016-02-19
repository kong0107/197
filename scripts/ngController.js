angular
.module('app', ['ngRoute'])
.config(function($routeProvider) {
	$routeProvider
	.when('/randomSelector', {
		templateUrl: 'randomSelector',
		controller: 'randomSelector'
	})
	.when('/grouping', {
		templateUrl: 'grouping',
		controller: 'grouping'
	})
	.otherwise({
		redirectTo: '/randomSelector'
	});
})
.controller('controller', function($scope) {
})
.controller('randomSelector', function($scope) {
	$scope.type = 'numbers';
	$scope.quantity = 3;
	$scope.minimum = 1;
	$scope.maximum = 10;
	$scope.result = [];

	$scope.inputs = [
		'bondage',
		'discipline',
		'http://hotline.org.tw/sites/hotline.org.tw/files/vigor_logo.png',
		'http://praatw.org/images/praa_1.gif'
	];
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
		$scope.lastExecution = new Date;
	}

	$scope.checkBlank();
})
.controller('grouping', function($scope) {
	$scope.maximum = 37;
	$scope.skips = ['29', '8'];
	$scope.capacity = 4;
	$scope.main = function() {
		var skips = $scope.skips.map(function(num) {return parseInt(num, 10);});

		// 把需要排序的先依序列出
		var arr = [];
		for(var i = 1; i <= $scope.maximum; ++i)
			if(skips.indexOf(i) == -1) arr.push(i);

		// 亂數排列
		// @see http://stackoverflow.com/questions/2450954/#2450976
		for(var i = arr.length - 1; i >= 0; --i) {
			var rand = Math.floor(Math.random() * (i + 1));
			var tmp = arr[i];
			arr[i] = arr[rand];
			arr[rand] = tmp;
		}

		// 依指定數量塞進結果中
		var result = [];
		while(arr.length >= $scope.capacity) {
			var cur = [];
			for(var i = 0; i < $scope.capacity; ++i)
				cur.push(arr.pop());
			result.push(cur);
		}

		// 把餘下的依序塞入陣列
		for(var i = 0; arr.length; ++i) result[i].push(arr.pop());

		$scope.result = result.reverse();
		$scope.lastExecution = new Date;
	};
});
