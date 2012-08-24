
<cfset application.datasource = "dailyreport" />
<cfset application.server = "wd00070228.active.local" />

<cfapplication name="Active" sessionmanagement="yes">

<cfif (not isdefined("session.user_id") or session.user_id eq 0) 
		and isdefined("CGI.HTTP_REFERER") 
			and not CGI.script_name contains "login.cfm" 
				and not CGI.script_name contains "send_daily_report.cfm"
					and not CGI.script_name contains "send_daily_report_QA.cfm">
	<script>
		self.location.href = '/dailyreport/login.cfm'
	</script>
</cfif>