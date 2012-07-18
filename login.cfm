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
	<link rel="stylesheet" href="css/report.css">
	<cfif cgi.HTTP_USER_AGENT contains "MSIE">
		<style type="text/css">
			.header{
				padding-left:18%;
			}
			.container{
			}
		</style>
	</cfif>
</head>
<body>
	<div class="header">
            <div class="wrapper">
                <h1>Daily Report</h1>
            </div>
        </div>
        <div class="container">
            <div>
                <div class="" align="center">
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
				<td colspan="2" align="center">
					<input type="submit" value="Login" name="submit" class="btn"></td>
			</tr>	
		</table>
	</form>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
        <div class="footer" align="center">
            <p>
				<img src="img/activenetwork_logo.png"><br>
                Copyright 2012 The Active Network&trade;
            </p>
        </div>

	</div>
</body>

</html>