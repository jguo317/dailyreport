<cfparam name="form.team_id" default="0" />
<cfparam name="url.team_id" default="0" />
<cfparam name="url.item_id" default="0" />
<cfparam name="form.item_id" default="0" />
<cfparam name="form.item_key" default="" />
<cfparam name="form.item_status" default="" />
<cfparam name="form.item_summary" default="" />
<cfparam name="form.item_priority" default="" />
<cfparam name="form.item_comment" default="" />
<cfparam name="form.item_timeframe" default="" />
<cfparam name="form.item_completed" default="0" />

<cfif form.team_id eq 0>
	<cfset form.team_id = url.team_id />
</cfif>
<cfif form.item_id eq 0>
	<cfset form.item_id = url.item_id />
</cfif>

<cfif isdefined('form.submit')>

	<cfif form.item_id eq 0>
		<cfquery name="insert" datasource="#application.datasource#">
			insert into item_status(item_key, item_status, item_summary, item_priority, item_comment, item_timeframe, item_completed, item_tester, item_reporter, item_frn_user_id, item_created)
			values ('#form.item_key#', #form.item_status#, '#form.item_summary#', #form.item_priority#, '#form.item_comment#', #form.item_timeframe#, #form.item_completed#, #session.user_id#, #session.user_id#, #session.user_id#, 0)
		</cfquery>
	<cfelse>
		<cfquery name="update" datasource="#application.datasource#">
			update item_status
			set item_key = '#form.item_key#',
				item_status = #form.item_status#,
				item_summary = '#form.item_summary#',
				item_priority = #form.item_priority#,
				item_comment = '#form.item_comment#',
				item_timeframe = #form.item_timeframe#,
				item_completed =  #form.item_completed#
			where item_id = #form.item_id#
		</cfquery>
	</cfif>
		
	<cflocation url="index.cfm?team_id=#form.team_id#" />
</cfif>

<cfif form.item_id neq 0>
	<cfquery name="getItem" datasource="#application.datasource#">
		select item_key, item_status,item_summary, item_priority, item_comment,item_timeframe,item_completed
		from item_status with(nolock)
		where item_id = #form.item_id#
	</cfquery>
	<cfset form.item_key = getItem.item_key />
	<cfset form.item_status = getItem.item_status />
	<cfset form.item_summary = getItem.item_summary />
	<cfset form.item_priority = getItem.item_priority />
	<cfset form.item_comment = getItem.item_comment />	
	<cfset form.item_timeframe = getItem.item_timeframe />
	<cfset form.item_completed = getItem.item_completed />
</cfif>


<cfquery name="getItemStatusType" datasource="#application.datasource#">
	select * from item_status_type with(nolock)	
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
						<form action="" method="post">
							<input type="hidden" name="team_id" value="#form.team_id#" />
							<input type="hidden" name="item_id" value="#form.item_id#">
						<table>
						<tr>
							<td>Key:</td>
							<td><input type="text" name="item_key" value="#form.item_key#"></td>
						</tr>
						<tr>
							<td>Summary:</td>
							<td><textarea name="item_summary">#form.item_summary#</textarea></td>
						</tr>
						<tr>
							<td>Status:</td>
							<td>
								<select name="item_status">
									<cfloop query="getItemStatusType">
										<option value="#ist_id#" <cfif ist_id eq form.item_status>selected</cfif>>#ist_name#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>Priority:</td>
							<td><input type="text" name="item_priority" value="#form.item_priority#"></td>
						</tr>
						<tr>
							<td>Comment:</td>
							<td><textarea name="item_comment">#form.item_comment#</textarea></td>
						</tr>
						
						<tr>
							<td>Completed:</td>
							<td><input type="text" name="item_completed" value="#form.item_completed#">%</td>
						</tr>
						<tr>
							<td>Timeframe:</td>
							<td><input type="text" name="item_timeframe" value="#form.item_timeframe#"></td>
						</tr>
						<tr><td colspan="2" align="center"><input type="submit" name="submit" value=" OK "></td></tr>
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