<cfparam name="form.team_id" default="0" />
<cfparam name="form.start_date" default="" />
<cfparam name="form.end_date" default="" />
<cfparam name="form.member_id" default="0" />
<cfparam name="form.isOracle" default="0" />
<cfset error_info = "" />

<cfif isdefined("form.preview")>
	<cfif not isDate("#form.start_date#") or not isDate("#form.end_date#")>
		<cfset error_info = "<font color='red'>The start date and end date must be a date.</font>">
	<cfelseif DateFormat("#form.end_date#") lt DateFormat("#form.start_date#")>
		<cfset error_info = "<font color='red'>The end date must not be less than the start date.</font>">
	<cfelse>
		<cfif form.isOracle>
			<cfif form.team_id eq 0>
				<cfset error_info = "<font color='red'>Please select a Team.</font>">
			<cfelseif form.member_id eq 0>
				<cfset error_info = "<font color='red'>Please select a Team Member.</font>">
			<cfelseif datediff('d', form.start_date, form.end_date) neq 6>
				<cfset error_info = "<font color='red'>The time inerval should be 7 days.</font>">
			<cfelse>
				<cflocation url="report_download_build_oracle.cfm?team_id=#form.team_id#&start_date=#form.start_date#&end_date=#form.end_date#&member_id=#form.member_id#" />		
			</cfif>
		<cfelse>
			<cflocation url="report_download_build.cfm?team_id=#form.team_id#&start_date=#form.start_date#&end_date=#form.end_date#&member_id=#form.member_id#" />
		</cfif>
	</cfif>
</cfif>


<cfquery name="getTeams" datasource="#application.datasource#">
	select distinct t.team_id, t.team_name
	from teams t with(nolock)
	join teams_to_users with(nolock) on ttu_frn_team_id = team_id
	where ttu_frn_user_id = #session.user_id#
</cfquery>

<cfif getTeams.recordcount eq 1>
	<cfset form.team_id = getTeams.team_id>
</cfif>

<cfif form.team_id gt 0>
	<cfquery name="getMembers" datasource="#application.datasource#">
		select user_id, user_fname + ' ' + user_lname as user_name
		from users with(nolock)
		join teams_to_users with(nolock) on ttu_frn_user_id = user_id and ttu_frn_team_id = #form.team_id#
	</cfquery>
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
		
		function changeTeam() {
			var rForm = document.report_form;
			rForm.submit();
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
				<cfinclude template="../common/downloadSidebar.cfm" />
                <!--- <div class="left-col">
                    <ul>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/index.cfm">Personal Report</a>
                        </li>
                        <li class="active">
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/team_report.cfm">Team Report</a>
                        </li>
						<li class="active">
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/team_report.cfm">Project Status</a>
                        </li>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/download/report_download.cfm">Report Download</a>
                        </li>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/login.cfm?logout=1">Logout</a>
                        </li>
                    </ul>
                </div> --->
                <div class="right-col">
                   <cfoutput>
		<form action="" method="post" name="report_form">
			<table>
				<tr><td colspan="2">#error_info#</td></tr>
				<tr>
					<td>Team : </td>
					<td><cfif getTeams.recordcount gt 1>
							<select name="team_id" style="width:200px" onchange="changeTeam();">
								<option value="0"></option>
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
					<td>Members : </td>
					<td>
							<select name="member_id" style="width:200px">
								<option value="0"></option>
								<cfif isdefined('getMembers')>
								<cfloop query="getMembers">
									<option value="#user_id#" <cfif form.member_id eq user_id>selected</cfif>>#user_name#</option>
								</cfloop>
								</cfif>
							</select>
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
					<td>Oracle Report : </td>
					<td>
						<input type="radio" name="isOracle" value="0" <cfif not form.isOracle>checked</cfif>>No
						&nbsp;&nbsp;
						<input type="radio" name="isOracle" value="1" <cfif form.isOracle>checked</cfif>>Yes
					</td>
				</tr>				
				<tr>
					<td colspan="2" align="center"><input type="submit" name="preview" value="Preview" class="btn"></td>
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
</body>
</html>