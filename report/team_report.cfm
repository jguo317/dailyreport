<cfparam name="form.team_id" default="0" />

<cfif form.team_id eq 0>
	<cfquery name="getTeams" datasource="#application.datasource#">
		select distinct t.team_id, t.team_name
		from teams t with(nolock)
		join teams_to_users with(nolock) on ttu_frn_team_id = team_id
		where ttu_frn_user_id = #session.user_id#
	</cfquery>
	<cfif getTeams.recordcount eq 1>
		<cfset form.team_id = getTeams.team_id>
	</cfif>
</cfif>
<cfif form.team_id neq 0>
	<cfquery name="getTeamMembers" datasource="#application.datasource#">
		select user_id, user_fname + ' ' + user_lname as user_name, ttu1.ttu_frn_team_id as team_id 
		from users
		join teams_to_users ttu1 on user_id = ttu1.ttu_frn_user_id and ttu1.ttu_frn_team_id = #form.team_id#
	</cfquery>
	
	<cfquery name="getReports" datasource="#application.datasource#">
		select distinct r.* 
		from reports r with(nolock) 
		join projects with(nolock) on project_id = report_frn_p_id 
		join teams_to_users with(nolock) on ttu_frn_user_id = report_frn_user_id
		where datediff(day, getdate(), report_timestamp) = 0 and ttu_frn_team_id = #form.team_id#
	</cfquery>
	
	<cfquery name="getProjects" datasource="#application.datasource#">
		select * from projects with(nolock)
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
                <cfinclude template="../common/teamSidebar.cfm">
                <div class="right-col">
                   <cfoutput>
		<cfif form.team_id eq 0>
			<form action="" method="post">
			<table>
				<tr>
					<td>Please Select a Team : </td>
					<td>
						<select name="team_id">
							<cfloop query="getTeams">
								<option value="#team_id#">#team_name#</option>
							</cfloop>
						</select>
					</td>
					<td><input type="submit" value="Search" class="btn btn-info"></td>
				</tr>
			</table>
			</form>
		<cfelse>
	<table border="1" width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<th width=150>Team Member</th>
			<th>Tasks</th>
			<th>Block</th>
		</tr>
		
		<cfloop query="getTeamMembers">
		<tr>
			<cfset userId = user_id />
			<td  align="center">#user_name#</td>
			<td>
				<table>
				<cfloop query="getProjects">
					<cfquery name="getMemberReportByProject" dbtype="query">
						select * from getReports where report_frn_user_id = #userId# and report_frn_p_id = #project_id#
					</cfquery>
					<cfif getMemberReportByProject.recordcount gt 0>
						<tr><td><b>#project_name# :</b> </td></tr>
					</cfif>
					<cfloop query="getMemberReportByProject">
						<tr><td style="padding-left:10px">
							<cfif report_details eq "">
								see jira item - 
							<cfelse>
								#report_details# - 					
							</cfif>
							#report_timeframe# h - #report_progress#% 
							<cfif report_jira neq "">- #report_jira#</cfif>
						</td></tr>
					</cfloop>
					<cfif getMemberReportByProject.recordcount gt 0>
						<tr><td>&nbsp;</td></tr>
					</cfif>
				</cfloop>
				</table>
			</td>
			<td>
				<cfquery name="getBlocks" dbtype="query">
					select * from getReports where report_frn_user_id = #getTeamMembers.user_id# and (report_block is not null or report_block != '')
				</cfquery>
				<table>
					<cfloop query="getBlocks">
						<tr><td>#report_block#</td></tr>
					</cfloop>
				</table>
			</td>
		</tr>	
		</cfloop>
		</table>
		</cfif>
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