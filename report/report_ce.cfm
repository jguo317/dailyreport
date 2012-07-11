<cfparam name="r_id" default="0" />
<cfparam name="p_id" default="0" />
<cfparam name="report_detail" default="" />
<cfparam name="report_jira" default="" />
<cfparam name="report_timeframe" default="" />
<cfparam name="report_progress" default="0" />
<cfparam name="report_block" default="" />
<cfset error_info = "" />

<cfquery name="getProjects" datasource="#application.datasource#">
	select * from projects with(nolock)
</cfquery>

<cfif isdefined("form.submit")>
	<cfset r_id = form.r_id />
	<cfset p_id = form.p_id />
	<cfset report_detail = form.report_detail />
	<cfset report_jira = form.report_jira />
	<cfset report_timeframe = form.report_timeframe />
	<cfset report_progress = form.report_progress />
	<cfset report_block = form.report_block />

	<cfif p_id eq 0>
		<cfset error_info = '<font color="red">Please select a project.</font>' />		
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
			           ,[report_block])
			     VALUES
			           (#p_id# 
			           ,'#report_detail#'
			           ,'#report_jira#'
			           ,#session.user_id#
			           ,'#report_timeframe#'
			           ,#report_progress#
			           ,'#report_block#')
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
	
</cfif>
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
<cfinclude template="../common/sidebar.cfm">
					<div class="sidebar_content">
	<cfoutput>
	<form action="" method="post">
		<span id="error_info" style="margin-bottom:10px;">#error_info#</span>
		<input type="hidden" name="r_id" value="#r_id#" /> 
		<table>
			<tr>
				<td>Project:</td>
				<td>
					<select name="p_id">
						<option value="0">
						<cfloop query="getProjects">
							<option value="#project_id#" <cfif project_id eq p_id>selected</cfif>>#project_name#</option>
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
				<td colspan="2" align="center"><input type="submit" name="Submit" value="Submit" class="btn btn-info"></td>
			</tr>		
		</table>	
	</form>
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