<cfparam name="form.team_id" default="0" />
<cfparam name="url.team_id" default="0" />

<cfif form.team_id eq 0>
	<cfset form.team_id = url.team_id />
</cfif>

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
	<cfquery name="getProjectStatus" datasource="#application.datasource#">
		
		select ps.*, project_name
		from project_status ps with(nolock)  
		join teams_to_users with(nolock) on ps_frn_user_id = ttu_frn_user_id and ttu_frn_team_id = #form.team_id#
		join projects with(nolock) on project_id = ps_frn_p_id 
		where datediff(day, getdate(), ps_timestamp) = 0
	</cfquery>
</cfif>

<cfquery name="getPojectOwner" datasource="#application.datasource#">
	select 1 from project_owners with(nolock) where po_frn_user_id = #session.user_id#
</cfquery>

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
		function create() {
			<cfoutput>self.location="project_status_ce.cfm?team_id=#form.team_id#";</cfoutput>
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
                   <cfinclude template="../common/statusSidebar.cfm" />
                </div>
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
			<th>Project</th>
			<th>Version</th>
			<th>Details</th>
			<th>Status</th>
			<th>Release Date</th>
		</tr>
		
		<cfloop query="getProjectStatus">
		<tr>			
			<td align="center">
				<cfif ps_frn_user_id eq session.user_id>
					<a href="project_status_ce.cfm?ps_id=#ps_id#&team_id=#form.team_id#">#project_name#</a>
				<cfelse>
					#project_name#
				</cfif>
			
			</td>
			<td align="center">#ps_version#</td>
			<td align="center" width="520px">#ps_details#</td>
			<td align="center" width="260px">
				<table>
					<tr>
						<td>Test Environment : </td>
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
			<td align="center">#dateformat(ps_release)#</td>
		</tr>	
		</cfloop>
		</table>
		<cfif getPojectOwner.recordcount gt 0>
			<table align=center>
				<tr><td><input type="button" name="submit" value="Create" onclick="create();"></td></tr>
			</table>
		</cfif>
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