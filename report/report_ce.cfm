<cfparam name="r_id" default="0" />
<cfparam name="p_id" default="0" />
<cfparam name="report_detail" default="" />
<cfparam name="report_jira" default="" />
<cfparam name="report_timeframe" default="" />
<cfparam name="report_progress" default="0" />
<cfparam name="report_block" default="" />
<cfparam name="report_frn_task_id" default="0" />
<cfset error_info = "" />

<cfquery name="getProjects" datasource="#application.datasource#">
	select * from projects with(nolock)
</cfquery>

<cfquery name="getTasks" datasource="#application.datasource#">
	select * from tasks with(nolock)
</cfquery>


<cfif isdefined("form.submit")>
	<cfset r_id = form.r_id />
	<cfset p_id = form.p_id />
	<cfset report_detail = form.report_detail />
	<cfset report_jira = form.report_jira />
	<cfset report_timeframe = form.report_timeframe />
	<cfset report_progress = form.report_progress />
	<cfset report_block = form.report_block />
	<cfset report_frn_task_id = form.report_frn_task_id />

	<cfif p_id eq 0>
		<cfset error_info = '<font color="red">Please select a project.</font>' />	
	<cfelseif report_frn_task_id eq 0>
		<cfset error_info = '<font color="red">Please select a task type.</font>' />		
	<cfelseif not IsNumeric(report_timeframe)>
		<cfset error_info = '<font color="red">The timeframe must be numeric.</font>' />
	<cfelseif not IsNumeric(report_progress) or report_progress gt 100 or report_progress lt 0>
		<cfset error_info = '<font color="red">The progress must be numeric between 0 to 100.</font>' />
	<cfelse>
		<cfif r_id gt 0>
			<cfquery name="updateReport" datasource="#application.datasource#">
			
				UPDATE [DailyReport].[dbo].[reports]
			   	SET [report_details] ='#report_detail#'
				      ,[report_jira] = '#report_jira#'
				      ,[report_frn_user_id] = #session.user_id#
				      ,[report_timeframe] = '#report_timeframe#'
				      ,[report_progress] = #report_progress#
				      ,[report_block] = '#report_block#'
				      ,[report_frn_p_id] = #p_id#
				      ,[report_frn_task_id] = #report_frn_task_id#
				WHERE report_id = #r_id#
			</cfquery>
		<cfelse>
			<cfquery name="insertReport" datasource="#application.datasource#">
				INSERT INTO [DailyReport].[dbo].[reports]
			            ([report_frn_p_id]
			           ,[report_details]
			           ,[report_jira]
			           ,[report_frn_user_id]
			           ,[report_timeframe]
			           ,[report_progress]
			           ,[report_block]
			           ,[report_frn_task_id])
			     VALUES
			           (#p_id# 
			           ,'#report_detail#'
			           ,'#report_jira#'
			           ,#session.user_id#
			           ,'#report_timeframe#'
			           ,#report_progress#
			           ,'#report_block#'
			           ,#report_frn_task_id#)
			</cfquery>
		</cfif>
		<script>
		self.location="index.cfm";		
		</script>
		
	</cfif>
<cfelse>
<cfif r_id gt 0>
	<cfquery name="getReport" datasource="#application.datasource#">
		select * from reports with(nolock) where report_id = #r_id#
	</cfquery>
	
	<cfset p_id = getReport.report_frn_p_id />
	<cfset report_detail = getReport.report_details />
	<cfset report_jira = getReport.report_jira />
	<cfset report_timeframe = getReport.report_timeframe />
	<cfset report_progress = getReport.report_progress />
	<cfset report_block = getReport.report_block />
	<cfset report_frn_task_id = getReport.report_frn_task_id />
	
</cfif>
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
                <cfinclude template="../common/sidebar.cfm">
                <div class="right-col">
                    	<cfoutput>
	<form action="" method="post">
		<span id="error_info" style="margin-bottom:10px;">#error_info#</span>
		<input type="hidden" name="r_id" value="#r_id#" /> 
		<table>
			<tr>
				<td>Project:</td>
				<td>
					<select name="p_id" style="width:200px;">
						<option value="0">
						<cfloop query="getProjects">
							<option value="#project_id#" <cfif project_id eq p_id>selected</cfif>>#project_name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td>Task Type:</td>
				<td>
					<select name="report_frn_task_id" style="width:200px;">
						<option value="0">
						<cfloop query="getTasks">
							<option value="#task_id#" <cfif task_id eq report_frn_task_id>selected</cfif>>#task_name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td>Detail:</td>
				<td><textarea name="report_detail" style="width:200px;" >#report_detail#</textarea></td>
			</tr>
			<tr>
				<td>Jira Item:</td>
				<td><input type="text" name="report_jira" value="#report_jira#" size="26px"></td>
			</tr>
			<tr>
				<td>TimeFrame:</td>
				<td><input type="text" name="report_timeframe" value="#report_timeframe#" size="26px">(H)</td>
			</tr>
			<tr>
				<td>Progress:</td>
				<td><input type="text" name="report_progress" value="#report_progress#" size="26px">%</td>
			</tr>
			<tr>
				<td>Block:</td>
				<td><textarea name="report_block" style="width:200px;">#report_block#</textarea></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" name="Submit" value="Submit" class="btn"></td>
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