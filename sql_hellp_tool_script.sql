USE [sql_help_tooltxt]
GO
/****** Object:  StoredProcedure [dbo].[sp_select]    Script Date: 2021/6/28 20:48:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_select](@sql varchar(1000))    
as    
begin    
set @sql='select * from ' + @sql;    
exec (@sql);    
end

GO
/****** Object:  StoredProcedure [dbo].[sp_table]    Script Date: 2021/6/28 20:48:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROC [dbo].[sp_table]
(
@tableName varchar(1000)
)
AS 
begin
		select  字段序号 = a.colorder ,
				字段名   = a.name ,
				主键	 = case when exists ( select  1   from    sysobjects  where   xtype = 'PK' and name in
									(select    name    from      sysindexes  where     indid in (select    indid 
										 from      sysindexkeys   where     id = a.id and colid = a.colid)) ) then '√' 
									else  ''
						  end ,
				类型 = b.name ,
				长度 = columnproperty(a.id, a.name, 'PRECISION') ,
				允许空 = case when a.isnullable = 1 then '√'
						   else ''
					  end ,
				默认值 = isnull(e.text, '') ,
				字段说明 = isnull(g.[value], '')
		from    syscolumns a
				left join systypes b on a.xusertype = b.xusertype
				inner join sysobjects d on a.id = d.id and d.xtype = 'U' and d.name <> 'dtproperties'
				left join syscomments e on a.cdefault = e.id
				left join sys.extended_properties g on a.id = g.major_id and a.colid = g.minor_id
				left join sys.extended_properties f on d.id = f.major_id and f.minor_id = 0
		where d.name= @tableName  --如果只查询指定表,加上此条件
		order by a.id ,
				a.colorder
end;

GO
/****** Object:  Table [dbo].[BigTable]    Script Date: 2021/6/28 20:48:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BigTable](
	[KEY] [int] NOT NULL,
	[DATA] [int] NULL,
	[PAD] [char](200) NULL,
 CONSTRAINT [PK1] PRIMARY KEY CLUSTERED 
(
	[KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SQL_DEBUG_SCRIPT]    Script Date: 2021/6/28 20:48:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQL_DEBUG_SCRIPT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SqlName] [nvarchar](100) NOT NULL,
	[SqlScript] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[SQL_DEBUG_SCRIPT] ON 

INSERT [dbo].[SQL_DEBUG_SCRIPT] ([ID], [SqlName], [SqlScript]) VALUES (1, N'sqlserver查询语句执行效率分析', N'SET STATISTICS PROFILE ON
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO /*--你的SQL脚本开始*/
select *
from LIS_JYXM;
GO
/*--你的SQL脚本结束*/
SET STATISTICS PROFILE OFF
SET STATISTICS IO OFF
 SET STATISTICS TIME OFF')
SET IDENTITY_INSERT [dbo].[SQL_DEBUG_SCRIPT] OFF
/****** Object:  Index [SQL_DEBUG_SCRIPT_pk]    Script Date: 2021/6/28 20:48:34 ******/
ALTER TABLE [dbo].[SQL_DEBUG_SCRIPT] ADD  CONSTRAINT [SQL_DEBUG_SCRIPT_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SQL调试语句' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SQL_DEBUG_SCRIPT'
GO
