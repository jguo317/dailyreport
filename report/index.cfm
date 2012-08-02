<cfquery name="getReports" datasource="#application.datasource#">
	select * from reports with(nolock) join projects with(nolock) on project_id = report_frn_p_id where datediff(day, getdate(), report_timestamp) = 0 and report_frn_user_id = #session.user_id#
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
		function CEReport(r_id) {
			self.location="report_ce.cfm?r_id="+r_id;
		}
	</script>
</head>
<body>
	<div class="header"  >
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
                <!--- <div class="left-col">
                    <ul>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/index.cfm">Personal Report</a>
                        </li>
                        <li class="active">
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/team_report.cfm">Team Report</a>
                        </li>
						<li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/report/team_report.cfm">Project Status</a>
                        </li>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/download/report_download.cfm">Report Download</a>
                        </li>
                        <li>
                            <a href="http://<cfoutput>#application.server#</cfoutput>/dailyreport/login.cfm?logout=1">Logout</a>
                        </li>
                    </ul>
                </div> --->
                <div class="right-col">
                    <cfoutput>
	<table cellpadding="4" cellspacing="0" border="1">
		<tr>
			<th>Project Name</th>
			<th>Detail</th>
			<th>Jira Item</th>
			<th>Times(H)</th>
			<th>Progress</th>
			<th>Block</th>
		<cfif getReports.recordcount GT 0>
			<th>Edit</th>
		</cfif>	
			
		</tr>
		<cfloop query="getReports">
		<tr>
			<td align="center">#project_name#</td>
			<td>#report_details#</td>
			<td><cfif LEN(#report_jira#) GT 0>#report_jira#<cfelse>&nbsp;</cfif></td>
			<td  align="center">#report_timeframe#</td>
			<td  align="center">#report_progress#%</td>
			<td><cfif len(#report_block#)>#report_block#<cfelse>&nbsp;</cfif></td>
			<td><input type="button" value="Edit" onclick="CEReport(#report_id#);" class="btn"></td>
		</tr>
		</cfloop>
		<tr>
			<td colspan="7" align="center">
				<input type="button" value="Create" onclick="CEReport(0);" class="btn">
			</td>
		</tr>
	</table>
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