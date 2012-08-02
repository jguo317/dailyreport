<cfparam name="date" default="#now()#">

<cfquery name="getTeams" datasource="#application.datasource#">
	select * from teams with(nolock) where team_send_email = 1
</cfquery>

<cfloop query="getTeams">
	<cfset EMAIL_FROM = "jay.guo@active.com" />
	<cfset emailTo = "jay.guo@active.com" />
	<cfset emailCc = "" />
	<cfset report_name = "Daily Report">
	<cfset email_subject = "Daily Report">
	
	<cfif team_send_email_from neq '' >
		<cfset EMAIL_FROM = team_send_email_from />
	</cfif>
	<cfif team_send_email_to neq '' >
		<cfset emailTo = team_send_email_to />
	</cfif>
	<cfif team_send_email_subject neq '' >
		<cfset email_subject = team_send_email_subject />
	</cfif>
	<cfif team_send_email_cc neq ''>
		<cfset emailCc = team_send_email_cc />
	</cfif>

	<cfquery name="getTeamMembers" datasource="#application.datasource#">
		select user_id, user_fname + ' ' + user_lname as user_name, ttu.ttu_frn_team_id as team_id, user_email
		from users
		join teams_to_users ttu on user_id = ttu.ttu_frn_user_id and ttu_frn_team_id = #team_id#
	</cfquery>
	
	<cfloop query="getTeamMembers">
		<cfset emailCc = emailCc & ';' & user_email />
	</cfloop>
	
	<cfquery name="getReports" datasource="#application.datasource#">
		select * from reports with(nolock) join projects with(nolock) on project_id = report_frn_p_id where datediff(day, #date#, report_timestamp) = 0
	</cfquery>
	
	<cfquery name="getProjects" datasource="#application.datasource#">
		select * from projects with(nolock)
	</cfquery>
	
	<cfsavecontent variable = "email_content">
		<cfoutput>
			<h1 align="center">#email_subject#</h1>
		<table border="1" align="center">
			<tr>
				<th>Team Member</th>
				<th>Tasks</th>
				<th>Block</th>
			</tr>
			
			<cfloop query="getTeamMembers">
			<tr>
				<td align="center">#user_name#</td>
				<cfset userId = user_id />
				<td>
					<table>
					<cfloop query="getProjects">
						<cfquery name="getMemberReportByProject" dbtype="query">
							select * from getReports where report_frn_user_id = #userId# and report_frn_p_id = #project_id#
						</cfquery>
						<cfif getMemberReportByProject.recordcount gt 0>
							<tr><td><b>#project_name# :</b></td></tr>
						</cfif>
						<cfloop query="getMemberReportByProject">
							<tr>
								<td>
									<cfif report_details eq "">
										see jira item - 
									<cfelse>
										#report_details# - 					
									</cfif>
									#report_timeframe# h - #report_progress#% 
									<cfif report_jira neq "">
										- #report_jira#
									</cfif>	
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
			<br>
			<h1 align="center">Project(s) Status</h1>
			<cfquery name="getProjectStatus" datasource="#application.datasource#">
		
				select ps.*, project_name
				from project_status ps with(nolock)  
				join teams_to_users with(nolock) on ps_frn_user_id = ttu_frn_user_id and ttu_frn_team_id = #team_id#
				join projects with(nolock) on project_id = ps_frn_p_id 
				where datediff(day, getdate(), ps_timestamp) = 0
			</cfquery>
			<table border="1" width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<th>Project</th>
			<th>Version</th>
			<th>Details</th>
			<th>Status</th>
			<th>Release Date</th>
		</tr>
		
		<cfloop query="getProjectStatus">
		<tr>			
			<td align="center">#project_name#</td>
			<td align="center">#ps_version#</td>
			<td align="center" width="520px">#ps_details#</td>
			<td align="center" width="260px">
				<table>
					<tr>
						<td>Test Environment : </b></td>
						<td>#ps_status#</td>
					</tr>
					<tr>
						<td>Total Items : </td>
						<td>#ps_item_total#</td>
					</tr>
					<tr>
						<td>Closed Items : </td>
						<td>#ps_item_closed#</td>
					</tr>
					<tr>
						<td>Items In Test Queue : </td>
						<td>#ps_item_tested#</td>
					</tr>
					<tr>
						<td>Items In Progress : </td>
						<td>#ps_item_open#</td>
					</tr>
				</table>
				
			</td>
			<td align="center" width="130px">#dateformat(ps_release)#</td>
		</tr>	
		</cfloop>
		</table>
		</cfoutput>
	</cfsavecontent>
	
	<cfmail from="#EMAIL_FROM#" to="#emailTo#" subject="#email_subject#" cc="#emailCc#" type="html">
		#email_content#
	</cfmail>
</cfloop>

<html>
	<head><title><cfoutput>#email_subject#</cfoutput></title></head>
	<body>
		<cfoutput>#email_content#</cfoutput>
	</body>
</html>