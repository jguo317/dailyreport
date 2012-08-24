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
	<cfquery name="getNewItems" datasource="#application.datasource#">
		
		select item_id, item_key, ist_name as 'item_status',item_summary, item_priority, item_comment, user_fname + ' ' + user_lname as 'user_name', user_id 
		from item_status with(nolock)
		join teams_to_users with(nolock) on item_frn_user_id = ttu_frn_user_id and ttu_frn_team_id = #form.team_id#
		join users with(nolock) on user_id = item_frn_user_id
		join item_status_type with(nolock) on ist_id = item_status
		where item_created = 1 and datediff(day, getdate(), item_timestamp) = 0
	</cfquery>
	
	<cfquery name="getTestItems" datasource="#application.datasource#">
		
		select item_id, item_key, ist_name as 'item_status',item_summary, item_priority, item_comment,item_timeframe,item_completed, user_fname + ' ' + user_lname as 'user_name', user_id
		from item_status with(nolock)
		join teams_to_users with(nolock) on item_frn_user_id = ttu_frn_user_id and ttu_frn_team_id = #form.team_id#
		join users with(nolock) on user_id = item_frn_user_id
		join item_status_type with(nolock) on ist_id = item_status
		where item_created = 0 and datediff(day, getdate(), item_timestamp) = 0
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
		function createNewItem() {
			<cfoutput>self.location="create_new_item.cfm?team_id=#form.team_id#";</cfoutput>
		}
		function createTestItem() {
			<cfoutput>self.location="create_test_item.cfm?team_id=#form.team_id#";</cfoutput>
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
                   <cfinclude template="../common/itemSidebar.cfm" />
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
		<p align="center"><b><font size="4" color="red">Test in Progress/Test Queue</font></b></p>
	<table border="1" width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<th>Key</th>
			<th>Summary</th>
			<th>Status</th>
			<th>Priority</th>
			<th>Tester</th>
			<th>% Complete</th>
			<th>Spent Time</th>
			<th>Comment</th>
		</tr>
		
		<cfloop query="getTestItems">
		<tr>			
			<td align="center">
				<cfif user_id eq session.user_id>
					<a href="create_test_item.cfm?team_id=#form.team_id#&item_id=#item_id#">#item_key#</a>
				<cfelse>
					#item_key#
				</cfif>
			
			</td>
			<td align="center">#item_summary#</td>
			<td align="center">#item_status#</td>
			<td align="center">#item_priority#</td>
			<td align="center">#user_name#</td>
			<td align="center">#item_completed#%</td>
			<td align="center">#item_timeframe#</td>
			<td align="center">#item_comment#</td>
		</tr>	
		</cfloop>
		<tr><td colspan="8" align="center"><input type="button" name="submit" value="Create" onclick="createTestItem();"></td></tr>
		</table>
		<br>
		<p align="center"><b><font size="4" color="red">New Open Issues</font></b></p>
		<table border="1" width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<th>Key</th>
			<th>Summary</th>
			<th>Status</th>
			<th>Priority</th>
			<th>Reporter</th>			
			<th>Comment</th>
		</tr>
		<cfloop query="getNewItems">
		<tr>			
			<td align="center">
				<cfif user_id eq session.user_id>
					<a href="create_new_item.cfm?team_id=#form.team_id#&item_id=#item_id#">#item_key#</a>
				<cfelse>
					#item_key#
				</cfif>
			
			</td>
			<td align="center">#item_summary#</td>
			<td align="center">#item_status#</td>
			<td align="center">#item_priority#</td>
			<td align="center">#user_name#</td>
			<td align="center">#item_comment#</td>
		</tr>	
		</cfloop>
		<tr><td colspan="6" align="center"><input type="button" name="submit" value="Create" onclick="createNewItem();"></td></tr>
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