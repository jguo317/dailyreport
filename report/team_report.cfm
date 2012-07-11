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
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/main.css">
</head>
<body>
	<div id="content">
		<div class="container">
		<cfinclude template="../common/header.cfm">
			<div class="block withsidebar">
				<div class="block_head">
					<div class="bheadl"></div>
					<div class="bheadr"></div>
					<h2>Report</h2>

				</div>
				<div class="block_content">
<cfinclude template="../common/teamSidebar.cfm">
					<div class="sidebar_content">
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
						<tr><td >
							<ul>
								<li>#report_details# - #report_timeframe# h - #report_progress#% 
						<cfif report_jira neq "">- #report_jira#</cfif></li>
							</ul>
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

				</div>
				<div class="bendl"></div>
				<div class="bendr"></div>

			</div>
			<!--/block withsidebar-->
			<cfinclude template="../common/footer.cfm">
		</div>
		<!--/.container -->
	</div>
	
	
	
</body>
</html>