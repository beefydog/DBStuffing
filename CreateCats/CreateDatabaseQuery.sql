CREATE DATABASE [TestDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestDB', FILENAME = N'D:\DB\TestDB.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TestDB_log', FILENAME = N'H:\DBLOGS\TestDB_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [TestDB] SET COMPATIBILITY_LEVEL = 140
GO
ALTER DATABASE [TestDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TestDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TestDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TestDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TestDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TestDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TestDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestDB] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [TestDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TestDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TestDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TestDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestDB] SET  READ_WRITE 
GO
ALTER DATABASE [TestDB] SET RECOVERY FULL 
GO
ALTER DATABASE [TestDB] SET  MULTI_USER 
GO
ALTER DATABASE [TestDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TestDB] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TestDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [TestDB]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [TestDB] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO