<cfquery name="getTeamMembers" datasource="#application.datasource#">
	select user_id, user_fname + ' ' + user_lname as user_name, ttu1.ttu_frn_team_id as team_id 
	from users
	join teams_to_users ttu1 on user_id = ttu1.ttu_frn_user_id and ttu1.ttu_frn_team_id = #team_id#
</cfquery>

<cfquery name="getReports" datasource="#application.datasource#">
	select distinct r.* 
	from reports r with(nolock) 
	join projects with(nolock) on project_id = report_frn_p_id 
	join teams_to_users with(nolock) on ttu_frn_user_id = report_frn_user_id
	where report_timestamp between '#start_date#' and '#end_date#' and ttu_frn_team_id = #team_id#
</cfquery>

<!--- <cfdump var="#getReports#"><br />
<cfabort> --->


<cfquery name="getProjects" datasource="#application.datasource#">
	select * from projects with(nolock)
</cfquery>

<cfheader name="content-disposition" value="inline;filename=dailyreport">
<cfcontent type="html/text">
<cfoutput>
	<html><head><title>dailyreport</title></head><body>
<table border="1" width="100%">
	<tr>
		<th>Project Name</th>
		<th>Team Member</th>
		<th>Tasks</th>
		<th>TimeFrame (H)</th>
		<th>Jira Item</th>
	</tr>
	
	<cfloop query="getTeamMembers">
	<tr>
		<cfset userId = user_id />
			<cfloop query="getProjects">
				<cfquery name="getMemberReportByProject" dbtype="query">
					select * from getReports where report_frn_user_id = #userId# and report_frn_p_id = #project_id#
				</cfquery>
				<cfif getMemberReportByProject.recordcount gt 0>
					<tr><td><b>#project_name# :</b> </td></tr>
				</cfif>
				<cfloop query="getMemberReportByProject">
					<td>#project_name#</td>
					<td>#user_name#</td>
					<td>#report_details#</td>
					<td>#report_timeframe#</td>
					<td>#report_jira#</td>
				</cfloop>
			</cfloop>
	</tr>	
	</cfloop>
</table>
</body></html>
<cfsetting enablecfoutputonly="false" />
<cfabort />
</cfoutput>