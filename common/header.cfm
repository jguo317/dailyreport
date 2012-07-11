<div class="navbar navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container">
			<a	class="brand" href="#">Daily Report</a>
			<cfif isdefined("session.user_name") and session.user_name gt 0>
			<div class="pull-right">
				<ul class="nav">
					<li><a> 
						Welcome! <i class="icon-user"></i> <cfoutput>#session.user_name#</cfoutput> </a>
					</li>
				</ul>
			</div>
			</cfif>
		</div>
	</div>
</div>
	
