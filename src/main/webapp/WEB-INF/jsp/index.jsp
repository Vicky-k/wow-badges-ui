<!DOCTYPE HTML>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache"> 
    <meta http-equiv="Cache-Control" content="no-cache"> 
    <meta http-equiv="Expires" content="Sat, 01 Dec 2020 00:00:00 GMT">
	
	<title>Cognizant Visitor Portal | Admin Home</title>
		
	<link rel="stylesheet" href="static/css/bootstrap.min.css">
	<link rel="stylesheet" href="static/css/style.css">    
</head>

<body>
	<div role="navigation">
		<div class="navbar navbar-default">
			<a href="/" class="navbar-brand">CVP Portal</a>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li><a href="search-page">Issue Badge</a></li>
					<li><a href="unreturned-search">Not Returned</a></li>
					<li><a href="new-badge">Create New Badge</a></li>
					<li><a href="return-search-page">Return Badge</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<c:choose>
		<c:when test="${mode == 'MODE_HOME'}">
		<div class="container text-center " id="taskDiv">
			<h3>All Badges</h3>
			<hr>
			<div class="table-responsive">
				<table class="table table-striped table-bordered text-left">
					<thead>
					<tr>
						<th>ID</th>
						<th>Status</th>
						<th>Used Flag</th>
					</tr>
					</thead>
					<tbody>
					<c:forEach var="bagde" items="${badges}">
						<tr>
							<td>${bagde.badgeId}</td>
							<td>${bagde.status}</td>
							<td>${bagde.usedFlag}</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</c:when>
		<c:when test="${mode == 'MODE_SEARCH' || mode == 'MODE_SEARCH_PAGE'}">
		<div class="container text-center " id="taskDiv">
			<h3>Search Reserved Badge</h3>
			<hr>
			<div>
			<form id="formSearch" class="form-horizontal" method="POST" action="/">
				<div class="table-responsive">
					<table align="center" border=0>
						<tr>
							<td style="padding: 15px;">
								<input class="form-control form-control-sm" type="text" placeholder="Badge Id" id="badgeId" name="badgeId">
							</td>
							<td>
								<input type="submit" class="btn btn-primary" value="Get Details">
							</td>
						</tr>
					</table>
				</div>
			</form>
			</div>
			<hr>

			<c:if test="${badgeId == 'invalid'}">
				<div align="center"> Badge Id is invalid </div>
			</c:if>

			<c:if test="${badgeId == 'empty'}">
				<div align="center"> Badge Id is empty </div>
			</c:if>
			<c:if test="${issue == 'success'}">
				<div align="center"> Badge Id is issued. </div>
			</c:if>
			<c:if test="${issue == 'failure'}">
				<div align="center"> Not able to Issue. </div>
			</c:if>

			<c:if test="${badgeId == 'nonempty'}">

			<div class="table-responsive">

					<c:if test="${reserved == 'Y'}">
						<table class="table table-striped table-bordered text-left">
							<thead>
							<tr>
								<th>Visitor Id</th>
								<th>First Name</th>
								<th>Last Name</th>
								<th>Badge Reserved</th>
								<th>Issuance</th>
							</tr>
							</thead>
							<tbody>
						<tr>
							<td>${badgeVisitorMap.visitorId}</td>
							<td>${badgeVisitorMap.firstName}</td>
							<td>${badgeVisitorMap.lastName}</td>
							<td>${badgeVisitorMap.badgeId}</td>
							<td>
								<form method="POST" action="/issue">
									<input type="hidden" name="badgeIdIssue" id="badgeIdIssue" value="${badgeVisitorMap.badgeId}">
									<input type="submit" class="btn btn-success" value="Issue">
								</form>
							</td>
						</tr>
							</tbody>
						</table>
					</c:if>
				<c:if test="${reserved == 'N'}">
					<div align="center"> Badge Id is not reserved </div>
				</c:if>

			</div>
			</c:if>
		</div>
	</c:when>
		<c:when test="${mode == 'MODE_RETURN_SEARCH_PAGE'}">

			<h3 align="center">Search Issued Badge</h3 >
			<hr>
			<div>
				<form id="formReturnSearch" class="form-horizontal" method="GET" action="/unreturned">
					<div class="table-responsive">
						<table align="center" border=0>
							<tr>
								<td style="padding: 15px;">
									<input class="form-control form-control-sm" type="text" placeholder="Badge Id" id="badgeReturnId" name="badgeReturnId">
								</td>
								<td>
									<input type="submit" class="btn btn-primary" value="Get Badge Details">
								</td>
							</tr>
						</table>
					</div>
				</form>
			</div>
			<c:if test="${getReturnBadgeDetails == 'success'}">
	<div class="col-xs-12">
		<div class="col-xs-3"></div>
		<div class="col-xs-6">
				<table class="table table-striped table-bordered text-left">
					<thead>

					<tr>
						<th>Visitor Id</th>
						<th>First Name</th>
						<th>Last Name</th>
						<th>Badge Reserved</th>
						<th>Issuance</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<td>${badgeVisitorMap.visitorId}</td>
						<td>${badgeVisitorMap.firstName}</td>
						<td>${badgeVisitorMap.lastName}</td>
						<td>${badgeVisitorMap.badgeId}</td>
						<td>
							<form method="POST" action="/return">
								<input type="hidden" name="badgeIdReturn" id="badgeIdReturn" value="${badgeVisitorMap.badgeId}">
								<input type="submit" class="btn btn-success" value="Return">
							</form>
						</td>
					</tr>

					</tbody>
				</table>
				</div>
				<div class="col-xs-3"></div>
			</c:if>

			<c:if test="${getReturnBadgeDetails == 'failure'}">
			<div align="center"> ${errorMessage} </div>
			</c:if>

		<c:if test="${returnResult == 'success'}">
		<div align="center"> Badge returned successfully</div>
		</c:if>
		<c:if test="${returnResult == 'failure'}">
		<div align="center"> Error in returning badge.</div>
		</c:if>

		</c:when>
		<c:when test="${mode == 'MODE_UNRETURNED'}">
		<br><br>
		<hr>
		<div class="col-xs-12">
			<div class="col-xs-3"></div>
			<div class="col-xs-6">
				<table class="table table-striped table-bordered text-left" align="center">
					<thead>
					<tr>
						<th>Badge Id</th>
						<th>Visitor Id</th>
						<th>First Name</th>
						<th>Last name</th>


					</tr>
					</thead>
					<tbody>
					<c:forEach var="mapping" items="${visitorBadgeMapping}">
						<tr>
							<td>${mapping.badgeId}</td>
							<td>${mapping.visitorId}</td>
							<td>${mapping.firstName}</td>
							<td>${mapping.lastName}</td>

						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="col-xs-3"></div>

		</div>
			<hr>
	</c:when>
	</c:choose>



	
	<script src="static/js/jquery-1.11.1.min.js"></script>
	<script src="static/js/bootstrap.min.js"></script>

</body>
</html>
