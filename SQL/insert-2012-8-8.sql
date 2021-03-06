INSERT INTO [dbo].[teams]
           ([team_name]
           ,[team_send_email]
           ,[team_send_email_from]
           ,[team_send_email_to]
           ,[team_send_email_subject]
           ,[team_send_email_cc])
     VALUES
           ('RC-QA'
           ,1
           ,'Ina.Wu@activenetwork.com'
           ,''
           ,'REG QA Daily Report '
           ,'Jessica.Wang@activenetwork.com')

INSERT INTO [dbo].[teams]
           ([team_name]
           ,[team_send_email]
           ,[team_send_email_from]
           ,[team_send_email_to]
           ,[team_send_email_subject]
           ,[team_send_email_cc])
     VALUES
           ('AI-QA'
           ,1
           ,'Ray.Geng@activenetwork.com'
           ,''
           ,'AI QA Daily Report '
           ,'Jessica.Wang@activenetwork.com')
GO
INSERT INTO [dbo].[users]
           ([user_fname]
           ,[user_lname]
           ,[user_email])
     VALUES
           ('Ina'
           ,'Wu'
           ,'Ina.Wu@activenetwork.com')
INSERT INTO [dbo].[users]
           ([user_fname]
           ,[user_lname]
           ,[user_email])
     VALUES
           ('Elaine'
           ,'Zeng'
           ,'Elaine.Zeng@activenetwork.com')
INSERT INTO [dbo].[users]
           ([user_fname]
           ,[user_lname]
           ,[user_email])
     VALUES
           ('Ray'
           ,'Geng'
           ,'Ray.Geng@activenetwork.com')
INSERT INTO [dbo].[users]
           ([user_fname]
           ,[user_lname]
           ,[user_email])
     VALUES
           ('Dacy'
           ,'Yang'
           ,'Dacy.Yan@activenetwork.com')
GO
INSERT INTO [dbo].[item_status_type]
           ([ist_name])
VALUES ('Test Queue')

INSERT INTO [dbo].[item_status_type]
           ([ist_name])
VALUES ('Test In Progress')

GO
INSERT INTO [dbo].[teams_to_users]
           ([ttu_frn_team_id]
           ,[ttu_frn_user_id])
SELECT team_id, user_id
from teams with(nolock) 
join users with(nolock) on user_email = 'ina.wu@activenetwork.com'
where team_name = 'RC-QA'

INSERT INTO [dbo].[teams_to_users]
           ([ttu_frn_team_id]
           ,[ttu_frn_user_id])
SELECT team_id, user_id
from teams with(nolock)
join users with(nolock) on user_email = 'elaine.zeng@activenetwork.com'
where team_name = 'RC-QA'

INSERT INTO [dbo].[teams_to_users]
           ([ttu_frn_team_id]
           ,[ttu_frn_user_id])
SELECT team_id, user_id
from teams with(nolock)
join users with(nolock) on user_email = 'Ray.Geng@activenetwork.com'
where team_name = 'AI-QA'

INSERT INTO [dbo].[teams_to_users]
           ([ttu_frn_team_id]
           ,[ttu_frn_user_id])
SELECT team_id, user_id
from teams with(nolock)
join users with(nolock) on user_email = 'dacy.yan@activenetwork.com'
where team_name = 'AI-QA'

GO
INSERT INTO [dbo].[user_access]
           ([ua_frn_user_id]
           ,[ua_username]
           ,[ua_password])
SELECT user_id, 'iwu', 'active123'
FROM users with(nolock) where user_email = 'ina.wu@activenetwork.com'
INSERT INTO [dbo].[user_access]
           ([ua_frn_user_id]
           ,[ua_username]
           ,[ua_password])
SELECT user_id, 'ezeng', 'active123'
FROM users with(nolock) where user_email = 'elaine.zeng@activenetwork.com'
INSERT INTO [dbo].[user_access]
           ([ua_frn_user_id]
           ,[ua_username]
           ,[ua_password])
SELECT user_id, 'rgeng', 'active123'
FROM users with(nolock) where user_email = 'ray.geng@activenetwork.com'
INSERT INTO [dbo].[user_access]
           ([ua_frn_user_id]
           ,[ua_username]
           ,[ua_password])
SELECT user_id, 'dyan', 'active123'
FROM users with(nolock) where user_email = 'dacy.yan@activenetwork.com'
