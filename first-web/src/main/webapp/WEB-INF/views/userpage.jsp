<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page session="true"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<body ng-app="myApp" ng-controller="userCtrl">

<div class="w3-container">
 <label>Welcome ${userName_} </label> 

<p>Message is: ${message }</p>
<h3>Users</h3>
<input class="w3-input w3-border" type="text" ng-model="sName" placeholder="Search Name">
<table class="w3-table w3-bordered w3-striped">
  <tr>
    <th>Edit</th>
    <th ng-click="orderByFunc('fName')">First Name</th>
    <th ng-click="orderByFunc('lName')">Last Name</th>
  </tr>
  <tr ng-repeat="user in users | orderBy:orderVar | filter: searchName() ">
    <td>
      <button class="w3-btn w3-ripple" ng-click="editUser(user.id)">&#9998; Edit</button>
	  <button class="w3-btn w3-ripple" ng-click="deleteUser(user.id)">&#9998; Delete</button>
    </td>
    <td>{{ user.fName }}</td>
    <td>{{ user.lName }}</td>
  </tr>
</table>
<br>
<button class="w3-btn w3-green w3-ripple" ng-click="editUser('new')">&#9998; Create New User</button>

<form ng-hide="hideform" method="post" action="/spring-mvc/userpage">
  <h3 ng-show="edit">Create New User:</h3>
  <h3 ng-hide="edit">Edit User:</h3>
    <label>First Name:</label>
    <input class="w3-input w3-border" type="text" ng-model="fName" ng-disabled="!edit" placeholder="First Name">
  <br>
    <label>Last Name:</label>
    <input class="w3-input w3-border" type="text" ng-model="lName" ng-disabled="!edit" placeholder="Last Name">
  <br>
    <label>Password:</label>
    <input class="w3-input w3-border" type="password" ng-model="passw1" placeholder="Password">
  <br>
    <label>Repeat:</label>
    <input class="w3-input w3-border" type="password" ng-model="passw2" placeholder="Repeat Password">
  <br>
  <button class="w3-btn w3-green w3-ripple" ng-disabled="error || incomplete" ng-click="addUser()">&#10004; Save Changes</button>
</form>

</div>

<script>
	angular.module('myApp', []).controller('userCtrl', function($scope,$http) {
	$scope.fName = '';
	$scope.lName = '';
	$scope.passw1 = '';
	$scope.passw2 = '';
	$scope.sName = '';
	$scope.users = [
	{id:1, fName:'Hege', lName:"Pege" },
	{id:2, fName:'Kim',  lName:"Pim" },
	{id:3, fName:'Sal',  lName:"Smith" },
	{id:4, fName:'Jack', lName:"Jones" },
	{id:5, fName:'John', lName:"Doe" },
	{id:6, fName:'Peter',lName:"Pan" }
	];
	$scope.edit = true;
	$scope.error = false;
	$scope.incomplete = false; 
	$scope.hideform = true; 
	$scope.editUser = function(id) {
	  $scope.hideform = false;
	  if (id == 'new') {
		$scope.edit = true;
		$scope.incomplete = true;
		$scope.fName = '';
		$scope.lName = '';
		} else {
		$scope.edit = false;
		$scope.fName = $scope.users[id-1].fName;
		$scope.lName = $scope.users[id-1].lName;
		$scope.passw1 = '';
		$scope.passw2 = '';	
	  }
	};
	$scope.deleteUser = function(id) {
		for(var i=0;i<$scope.users.length;i++) {
			if($scope.users[i].id === id) {
				$scope.users.splice(i,1);
				break;
			}
		}
	}
	$scope.addUser = function() {
		//alert("giving id: "+$scope.users.length)
		/*var probableId = $scope.users.length + 1;
		for(var i=0;i<$scope.users.length;i++) {
			if($scope.users[i].id === probableId) {
				//generate another Id
				for(var j=i;j>=1;j--) {
					if($scope.users[j].id != j)
				}
			}
		}
		//TODO: ID Generation
		*/
		/*Submit the form*/
		$http({
            method : 'POST',
            url : '/spring-mvc/userpage',
            data : JSON.stringify({"firstName":$scope.fName,"lastName":$scope.lName,"password":$scope.passw1}),
            contentType : 'application/json; charset=utf-8',
        	dataType : 'json'
        }).then(function mysuccess(response){
        	console.log(response);
        	alert("Response: " + response.data.firstName + " " + response.data.lastName + " " + response.data.password);
        });
		
		$scope.users.push( { id:$scope.users.length+1, fName:$scope.fName, lName:$scope.lName } );
		$scope.fName = '';
		$scope.lName = '';
		$scope.passw1 = '';
		$scope.passw2 = '';
	}
	
	$scope.orderByFunc = function(x) {
		$scope.orderVar = x;
	}
	$scope.searchName = function() {
		return function(user) {
			if($scope.sName.length == 0)
				return true;
			return (user.fName.toLowerCase().indexOf($scope.sName.toLowerCase())!=-1 || user.lName.toLowerCase().indexOf($scope.sName.toLowerCase())!=-1);
		}
		
	}
	$scope.$watch('passw1',function() {$scope.test();});
	$scope.$watch('passw2',function() {$scope.test();});
	$scope.$watch('fName', function() {$scope.test();});
	$scope.$watch('lName', function() {$scope.test();});

	$scope.test = function() {
	  if ($scope.passw1 !== $scope.passw2) {
		$scope.error = true;
		} else {
		$scope.error = false;
	  }
	  $scope.incomplete = false;
	  if ($scope.edit && (!$scope.fName.length ||
	  !$scope.lName.length ||
	  !$scope.passw1.length || !$scope.passw2.length)) {
		 $scope.incomplete = true;
	  }
	};

	});





</script>

</body>
</html>

