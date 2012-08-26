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
<!--- <cfquery name="getTeamMembers" datasource="#application.datasource#">
	select user_id, user_fname + ' ' + user_lname as user_name, ttu1.ttu_frn_team_id as team_id 
	from users
	join teams_to_users ttu1 on user_id = ttu1.ttu_frn_user_id and ttu1.ttu_frn_team_id = #team_id#
	<cfif member_id gt 0>
		where user_id = #member_id#
	</cfif>	
</cfquery> --->

<cfstoredproc procedure="dr_getReportsForOracle" datasource="#application.datasource#">
	<cfprocparam cfsqltype="cf_SQL_DATE" value="#start_date#">
	<cfprocparam cfsqltype="cf_SQL_DATE" value="#end_date#">
	<cfprocparam cfsqltype="cf_SQL_INTEGER" value="#member_id#">
	<cfprocresult name="getReports">

</cfstoredproc>

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
		<th>Task</th>
		<th>Task Type</th>
		<th>#start_date#</th>
		<th>#dateformat(dateadd("d",1,start_date), "mm-dd-yy")#</th>
		<th>#dateformat(dateadd("d",2,start_date), "mm-dd-yy")#</th>
		<th>#dateformat(dateadd("d",3,start_date), "mm-dd-yy")#</th>
		<th>#dateformat(dateadd("d",4,start_date), "mm-dd-yy")#</th>
		<th>#dateformat(dateadd("d",5,start_date), "mm-dd-yy")#</th>
		<th>#dateformat(dateadd("d",6,start_date), "mm-dd-yy")#</th>
	</tr>
	
	<cfloop query="getReports">
		<tr>
		
			<td>#project_name_oracle#</td>
			<td>#task_number#</td>
			<td>#application.task_type#</td>
			<td>#t1#</td>
			<td>#t2#</td>
			<td>#t3#</td>
			<td>#t4#</td>
			<td>#t5#</td>
			<td>#t6#</td>
			<td>#t7#</td>			
		</tr>
		
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