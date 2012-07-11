<cfquery name="getReports" datasource="#application.datasource#">
	select * from reports with(nolock) join projects with(nolock) on project_id = report_frn_p_id where datediff(day, getdate(), report_timestamp) = 0 and report_frn_user_id = #session.user_id#
</cfquery>
<html>
<head>
	<title>Daily Report</title>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/main.css">
	<script>
		function CEReport(r_id) {
			self.location="report_ce.cfm?r_id="+r_id;
		}
	</script>
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
	<table cellpadding="4" cellspacing="0" border="1" style="border:1px solid black">
		<tr>
			<th>Project Name</th>
			<th>Detail</th>
			<th>Jira Item</th>
			<th>Times(H)</th>
			<th>Progress</th>
			<th>Block</th>
			<th></th>
		</tr>
		<cfloop query="getReports">
		<tr>
			<td align="center">#project_name#</td>
			<td>#report_details#</td>
			<td>#report_jira#</td>
			<td  align="center">#report_timeframe#</td>
			<td  align="center">#report_progress#%</td>
			<td>#report_block#</td>
			<td><input type="button" value="Edit" onclick="CEReport(#report_id#);" class="btn btn-info"></td>
		</tr>
		</cfloop>
		<tr>
			<td colspan="7" align="center">
				<input type="button" value="Create" onclick="CEReport(0);" class="btn btn-info">
			</td>
		</tr>
	</table>
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