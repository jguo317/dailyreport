<cfparam name="form.username" default="" />
<cfparam name="logout" default="0" />
<cfset errorInfo="">
<cfif logout>
	<cflock scope="session" timeout="2">
		<cfset session.user_id = 0 />
		<cfset session.user_name = "" />
	</cflock>
</cfif>
<cfif isdefined('form.submit')>
	<cfquery name="getUserInfo" datasource="#application.datasource#">
		select * from user_access with(nolock) where ua_username = '#form.username#' and ua_password = '#form.password#'
	</cfquery>
	<cfif getUserInfo.recordCount gt 0>
		<cflock scope="session" timeout="2">
			<cfset session.user_id = getUserInfo.ua_frn_user_id />
			<cfset session.user_name = getUserInfo.ua_username />
		</cflock>
		<script>
			self.location.href = '/dailyreport/report/index.cfm'
		</script>
	<cfelse>
		<cfset errorInfo="<p align='center'><font color='red'>Invalid login information.</font></p>" />
	</cfif>
	
</cfif>

<html>
<head>
	<title>Daily Report</title>
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<div id="content">
		<div class="container">
		<cfinclude template="common/header.cfm">
			<div class="block withsidebar">
					<div class="sidebar_content">
						<cfoutput >#errorInfo#</cfoutput>
	<form action="" method="post">
		<table align="center">
			<tr>
				<td>UserName:</td>
				<td><input type="text" name="username"></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type="password" name="password"></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" value="Login" name="submit"></td>
			</tr>	
		</table>
	</form>
					</div>


			</div>
			<!--/block withsidebar-->
			<cfinclude template="common/footer.cfm">
		</div>
		<!--/.container -->
	</div>
</body>

</html>