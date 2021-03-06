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
                <div class="right-col">
<cfquery name="getTeamMembers" datasource="#application.datasource#">
	select user_id, user_fname + ' ' + user_lname as user_name, ttu1.ttu_frn_team_id as team_id 
	from users
	join teams_to_users ttu1 on user_id = ttu1.ttu_frn_user_id and ttu1.ttu_frn_team_id = #team_id#
	<cfif member_id gt 0>
		where user_id = #member_id#
	</cfif>	
</cfquery>

<cfquery name="getReports" datasource="#application.datasource#">
	select distinct r.*, p.*
	from reports r with(nolock) 
	join projects p with(nolock) on project_id = report_frn_p_id 
	join teams_to_users with(nolock) on ttu_frn_user_id = report_frn_user_id
	where report_timestamp between '#start_date#' and '#end_date#' and ttu_frn_team_id = #team_id#
</cfquery>

<!--- <cfdump var="#getReports#"><br />
<cfabort> --->


<cfquery name="getProjects" datasource="#application.datasource#">
	select * from projects with(nolock)
</cfquery>
<cfif isDefined("form.preview")>
	<cfheader name="content-disposition" value="inline;filename=download.txt">
	<cfcontent type="text/html">
<cfelseif isDefined("form.download")>
	<cfheader name="content-disposition" value="inline;filename=dailyreport">
	<cfcontent type="html/text">
</cfif>
<cfoutput>
	<html><head><title>dailyreport</title></head><body>
<table border="1" width="100%">
	<tr>
		<th>Project Name</th>
		<th>Team Member</th>
		<th>Tasks</th>
		<th>TimeFrame (H)</th>
		<th>Jira Item</th>
		<th>Date</th>
	</tr>
	
	<cfloop query="getTeamMembers">
	
		<cfset userId = user_id />
		<cfset user_name = user_name />
			<cfloop query="getProjects">
				<cfquery name="getMemberReportByProject" dbtype="query">
					select * from getReports where report_frn_user_id = #userId# and report_frn_p_id = #project_id#
				</cfquery>
				
				<cfloop query="getMemberReportByProject">
					<tr><td>#project_name#</td>
					<td>#user_name#</td>
					<td>#report_details#</td>
					<td>#report_timeframe#</td>
					<td>#report_jira#</td>
					<td>#dateformat(report_timestamp)#</td>
					</tr>
				</cfloop>
			</cfloop>
		
	</cfloop>
</table>
</body></html>
<cfsetting enablecfoutputonly="false" />

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