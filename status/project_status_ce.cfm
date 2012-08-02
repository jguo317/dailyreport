<cfparam name="url.ps_id" default="0" />
<cfparam name="form.ps_id" default="0" />
<cfparam name="form.p_id" default="0" />
<cfparam name="form.p_version" default="" />
<cfparam name="form.p_details" default="" />
<cfparam name="form.p_status" default="" />
<cfparam name="form.p_item_total" default="0" />
<cfparam name="form.p_item_closed" default="0" />
<cfparam name="form.p_item_open" default="0" />
<cfparam name="form.p_item_tested" default="0" />
<cfparam name="form.p_release" default="" />
<cfparam name="url.team_id" default="0" />
<cfparam name="form.team_id" default="0" />
<cfif form.team_id eq 0>
	<cfset form.team_id = url.team_id />
</cfif>
<cfif form.ps_id eq 0>
	<cfset form.ps_id = url.ps_id>
</cfif>
<cfset error_info = "" />

<cfquery name="getProjects" datasource="#application.datasource#">
	select * from projects with(nolock) join project_owners with(nolock) on project_id = po_frn_p_id and po_frn_user_id = #session.user_id#
</cfquery>

<cfif isdefined("form.submit")>
<cfdump var="11111">

	<cfif form.p_id eq 0>
		<cfset error_info = '<font color="red">Please select a project.</font>' />		
	<cfelseif form.p_status eq ''>
		<cfset error_info = '<font color="red">Please select the test environment.</font>' />
	<cfelseif form.p_release eq ''>
		<cfset error_info = '<font color="red">Please fill in the release date.</font>' />
	<cfelse>
		<cfif form.ps_id gt 0>
			<cfquery name="updatePS" datasource="#application.datasource#">
				UPDATE .[dbo].[project_status]
				SET [ps_version] = '#form.p_version#'
				  ,[ps_frn_p_id] = #form.p_id#
				  ,[ps_details] = '#form.p_details#'
				  ,[ps_status] = '#form.p_status#'
				  ,[ps_release] = '#form.p_release#'
				  ,[ps_frn_user_id] = #session.user_id#
				  ,[ps_item_total] = #form.p_item_total#
				  ,[ps_item_open] = #form.p_item_open#
				  ,[ps_item_closed] = #form.p_item_closed#
				  ,[ps_item_tested] = #form.p_item_tested#
				WHERE ps_id = #form.ps_id#
			</cfquery>
		<cfelse>
			<cfquery name="insertPS" datasource="#application.datasource#">
				INSERT INTO .[dbo].[project_status]
				       ([ps_version]
				       ,[ps_frn_p_id]
				       ,[ps_details]
				       ,[ps_status]
				       ,[ps_release]
				       ,[ps_frn_user_id]
				       ,[ps_item_total]
				       ,[ps_item_open]
				       ,[ps_item_closed]
				       ,[ps_item_tested])
				 VALUES
				       ('#form.p_version#'
				       ,#form.p_id#
				       ,'#form.p_details#'
				       ,'#form.p_status#'
				       ,'#form.p_release#'
				       ,#session.user_id#
				       ,#form.p_item_total#
				       ,#form.p_item_open#
				       ,#form.p_item_closed#
				       ,#form.p_item_tested#)
			</cfquery>
		</cfif>
		<script>
			<cfoutput>self.location="project_status.cfm?team_id=#form.team_id#";</cfoutput>		
		</script>
		
	</cfif>
<cfelse>
	<cfif form.ps_id gt 0>
		<cfdump var="22222">
		<cfquery name="getPS" datasource="#application.datasource#">
			select * from project_status with(nolock) where ps_id = #form.ps_id#
		</cfquery>
		<cfset form.p_id = getPS.ps_frn_p_id />
		<cfset form.p_version = getPS.ps_version />
		<cfset form.p_details = getPS.ps_details />
		<cfset form.p_status = getPS.ps_status />
		<cfset form.p_item_total = getPS.ps_item_total />
		<cfset form.p_item_closed = getPS.ps_item_closed />
		<cfset form.p_item_open = getPS.ps_item_open />
		<cfset form.p_item_tested = getPS.ps_item_tested />
		<cfset form.p_release = getPS.ps_release />
		
	</cfif>
</cfif>

<cfif form.p_release neq ''>
	<cfset form.p_release = dateformat(form.p_release) />
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
                <cfinclude template="../common/statusSidebar.cfm" />
                <div class="right-col">
                    	<cfoutput>
	<form action="" method="post">
		<span id="error_info" style="margin-bottom:10px;">#error_info#</span>
		<input type="hidden" name="team_id" value="#form.team_id#" /> 
		<input type="hidden" name="ps_id" value="#form.ps_id#" /> 
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
				<td>Version:</td>
				<td><textarea name="p_version" style="width:200px;" >#form.p_version#</textarea></td>
			</tr>
			<tr>
				<td>Detail:</td>
				<td><textarea name="p_details" style="width:200px;" >#form.p_details#</textarea></td>
			</tr>
			<tr>
				<td>Test On:</td>
				<td>
				<select name="p_status" style="width:200px;">
					<option value="">
					<option value="Local" <cfif form.p_status eq 'Local'>selected</cfif>>Local</option>
					<option value="INT" <cfif form.p_status eq 'INT'>selected</cfif>>INT</option>
					<option value="QA" <cfif form.p_status eq 'QA'>selected</cfif>>QA</option>
					<option value="STG" <cfif form.p_status eq 'STG'>selected</cfif>>STG</option>
					<option value="PROD" <cfif form.p_status eq 'PROD'>selected</cfif>>PROD</option>
				</select>
				</td>
			</tr>
			<tr>
				<td>Total Items:</td>
				<td><input type="text" name="p_item_total" value="#form.p_item_total#" size="26px"></td>
			</tr>
			<tr>
				<td>Closed Items:</td>
				<td><input type="text" name="p_item_closed" value="#form.p_item_closed#" size="26px"></td>
			</tr>
			<tr>
				<td>Items In Test Queue:</td>
				<td><input type="text" name="p_item_tested" value="#form.p_item_tested#" size="26px"></td>
			</tr>
			<tr>
				<td>Items In Progress:</td>
				<td><input type="text" name="p_item_open" value="#form.p_item_open#" size="26px"></td>
			</tr>
			<tr>
				<td>Release Date:</td>
				<td><input type="text" name="p_release" value="#form.p_release#" size="26px"></td>
			</tr>
			<tr>
				<td colspan=2 align="center">
					<input type="submit" name="submit" value="OK">
				</td>
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