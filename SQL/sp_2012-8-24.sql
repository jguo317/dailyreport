create procedure dbo.dr_getReportsForOracle
	@startDate datetime,
	@endDate datetime,
	@userId int
	
as

begin 
	select project_name_oracle, task_number, convert(varchar(10), report_timestamp, 10) as report_date, sum(report_timeframe) as report_timeframe
	into #temp
	from reports with(nolock)
	join projects with(nolock) on report_frn_p_id = project_id
	join tasks with(nolock) on report_frn_task_id = task_id
	where report_timestamp between @startDate and @endDate and report_frn_user_id = @userId
	group by project_name_oracle, task_number, convert(varchar(10), report_timestamp, 10)
	
	select distinct r.project_name_oracle, r.task_number,
			isnull(r1.report_timeframe, 0) as 't1',
			isnull(r2.report_timeframe, 0) as 't2',
			isnull(r3.report_timeframe, 0) as 't3',
			isnull(r4.report_timeframe, 0) as 't4',
			isnull(r5.report_timeframe, 0) as 't5',
			isnull(r6.report_timeframe, 0) as 't6',
			isnull(r7.report_timeframe, 0) as 't7'
	from #temp r
	left join #temp r1 on r.project_name_oracle = r1.project_name_oracle and r.task_number=r1.task_number and datediff(dd, r1.report_date, @startDate) = 0
	left join #temp r2 on r.project_name_oracle = r2.project_name_oracle and r.task_number=r2.task_number and datediff(dd, r2.report_date, dateadd(d, 1, @startDate)) = 0
	left join #temp r3 on r.project_name_oracle = r3.project_name_oracle and r.task_number=r3.task_number and datediff(dd, r3.report_date, dateadd(d, 2, @startDate)) = 0
	left join #temp r4 on r.project_name_oracle = r4.project_name_oracle and r.task_number=r4.task_number and datediff(dd, r4.report_date, dateadd(d, 3, @startDate)) = 0
	left join #temp r5 on r.project_name_oracle = r5.project_name_oracle and r.task_number=r5.task_number and datediff(dd, r5.report_date, dateadd(d, 4, @startDate)) = 0
	left join #temp r6 on r.project_name_oracle = r6.project_name_oracle and r.task_number=r6.task_number and datediff(dd, r6.report_date, dateadd(d, 5, @startDate)) = 0
	left join #temp r7 on r.project_name_oracle = r7.project_name_oracle and r.task_number=r7.task_number and datediff(dd, r7.report_date, dateadd(d, 6, @startDate)) = 0
end