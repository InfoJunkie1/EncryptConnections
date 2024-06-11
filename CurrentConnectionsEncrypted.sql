USE Master 
GO

SELECT con.encrypt_option
	, @@SERVERNAME AS ServerName
	, DB_NAME (s.database_id) AS DatabaseName
	, s.login_name AS LoginName
	, CAST(s.login_time AS SMALLDATETIME) AS LoginTime
	, s.host_name AS HostName
	, s.program_name AS ProgramName
	, s.client_interface_name
	, con.net_transport
	, auth_scheme
	, CAST(s.last_request_start_time AS smalldatetime) AS LastRequestStart
	, CAST(s.last_request_end_time AS smalldatetime) AS LastRequestEnd

FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_requests AS r
	ON s.session_id = r.session_id
		AND s.last_request_start_time = r.start_time
LEFT JOIN sys.dm_exec_connections AS con
	ON con.session_id = s.session_id
WHERE s.login_name NOT IN ('sa')
	--AND con.net_transport <> 'Shared memory'
	AND s.login_name NOT LIKE '%NT SERVICE%'
ORDER BY s.session_id