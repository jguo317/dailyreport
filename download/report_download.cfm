<cfparam name="form.team_id" default="0" />
<cfparam name="form.start_date" default="" />
<cfparam name="form.end_date" default="" />
<cfset error_info = "" />

<cfquery name="getTeams" datasource="#application.datasource#">
	select distinct t.team_id, t.team_name
	from teams t with(nolock)
	join teams_to_users with(nolock) on ttu_frn_team_id = team_id
	where ttu_frn_user_id = #session.user_id#
</cfquery>

<cfif isdefined("form.submit")>
	<cfif not isDate("#form.start_date#") or not isDate("#form.end_date#")>
		<cfset error_info = "<font color='red'>The start date and end date must be a date.</font>">
	<cfelseif DateFormat("#form.end_date#") lt DateFormat("#form.start_date#")>
		<cfset error_info = "<font color='red'>The end date must not be less than the start date.</font>">
	</cfif>
	<cflocation url="report_download_build.cfm?team_id=#form.team_id#&start_date=#form.start_date#&end_date=#form.end_date#" />
</cfif>

<html>
<head>
	<title>Daily Report</title>
	<link rel="stylesheet" href="../css/report.css">
		<cfif cgi.HTTP_USER_AGENT contains "MSIE">
		<style type="text/css">
			.header{
				padding-left:18%;
			}
			.container{
				margin-left: 20%;
			}
		</style>
	</cfif>
	<script>
		function CEReport(r_id) {
			self.location="report_ce.cfm?r_id="+r_id;
		}
	</script>
</head>
<body>
	<div class="header">
            <div class="wrapper">
                <cfif isdefined("session.user_name") and session.user_name gt 0>
                <span class="login">Welcome <cfoutput>#session.user_name#</cfoutput></span>
				</cfif>
                <h1>Daily Report</h1>
            </div>
        </div>
        <div class="container">
            <div class="wrapper">
                <div class="left-col">
                    <ul>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/index.cfm">Personal Report</a>
                        </li>
                        <li class="active">
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/team_report.cfm">Team Report</a>
                        </li>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/download/report_download.cfm">Report Download</a>
                        </li>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/login.cfm?logout=1">Logout</a>
                        </li>
                    </ul>
                </div>
                <div class="right-col">
                   <cfoutput>
		<form action="" method="post">
			<table>
				<tr><td colspan="2">#error_info#</td></tr>
				<tr>
					<td>Team : </td>
					<td><cfif getTeams.recordcount gt 1>
							<select name="team_id" style="width:200px">
								<cfloop query="getTeams">
									<option value="#team_id#" <cfif form.team_id eq team_id>selected</cfif>>#team_name#</option>
								</cfloop>
							</select>
						<cfelse>
							<input type="text" value="#getTeams.team_name#" disabled>
							<input type="hidden" name="team_id" value="#getTeams.team_id#">
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Start Date : </td>
					<td><input type="text" name="start_date" value="#form.start_date#" size="27px"></td>
				</tr>
				<tr>
					<td>End Date : </td>
					<td><input type="text" name="end_date" value="#form.end_date#" size="27px"></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input type="submit" name="submit" value="Download" class="btn"></td>
				</tr>
			
			</table>
		</form>
	</cfoutput>
                </div>
                <div class="clear">
                </div>
            </div>
        </div>
        <div class="footer" align="center">
            <p>
				<img src="../img/activenetwork_logo.png"><br>
                Copyright 2012 The Active Network&trade;
            </p>
        </div>
	
	
	
	
	
	
	
	
	
<!--- <div id="content">
		<div class="container">
		<cfinclude template="../common/header.cfm">
			<div class="block withsidebar">
				<div class="block_head">
					<div class="bheadl"></div>
					<div class="bheadr"></div>
					<h2>Report</h2>

				</div>
				<div class="block_content">
<cfinclude template="../common/downloadSidebar.cfm">
					<div class="sidebar_content">
	<cfoutput>
		<form action="" method="post">
			<table>
				<tr><td colspan="2">#error_info#</td></tr>
				<tr>
					<td>Team : </td>
					<td><cfif getTeams.recordcount gt 1>
							<select name="team_id" style="width:200px">
								<cfloop query="getTeams">
									<option value="#team_id#" <cfif form.team_id eq team_id>selected</cfif>>#team_name#</option>
								</cfloop>
							</select>
						<cfelse>
							<input type="text" value="#getTeams.team_name#" disabled>
							<input type="hidden" name="team_id" value="#getTeams.team_id#">
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Start Date : </td>
					<td><input type="text" name="start_date" value="#form.start_date#" size="27px"></td>
				</tr>
				<tr>
					<td>End Date : </td>
					<td><input type="text" name="end_date" value="#form.end_date#" size="27px"></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input type="submit" name="submit" value="Download" class="btn btn-info"></td>
				</tr>
			
			</table>
		</form>
	</cfoutput>
	
					</div>

				</div>
				<div class="bendl"></div>
				<div class="bendr"></div>

			</div>
			<!--/block withsidebar-->
			<cfinclude template="../common/footer.cfm">
		</div>
		<!--/.container -->
	</div> --->
</body>
</html>