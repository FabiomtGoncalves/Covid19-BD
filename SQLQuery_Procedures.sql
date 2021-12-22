USE COVID19
GO


CREATE PROCEDURE sp_DadosPortugal
AS
BEGIN	
   DECLARE @AtivosPortugal INT
   DECLARE @RecuperadosPortugal INT
   DECLARE @ObitosPortugal INT
   DECLARE @ConfirmadosPortugal INT
   DECLARE @Total_testesPortugal INT
   
   SET @AtivosPortugal = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 1 AND Paises.cod_Pais = 170)
   SET @RecuperadosPortugal = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 2 AND Paises.cod_Pais = 170)
   SET @ObitosPortugal = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 3 AND Paises.cod_Pais = 170)
   SET @ConfirmadosPortugal = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE Paises.cod_Pais = 170)
   SET @Total_testesPortugal = (SELECT SUM(Nr_testes) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE Paises.cod_Pais = 170)
   
   
   SELECT @AtivosPortugal AS 'Casos Ativos', @RecuperadosPortugal AS 'Recuperados', @ObitosPortugal AS 'Óbitos', @ConfirmadosPortugal AS 'Casos Confirmados',
   @Total_testesPortugal AS 'Total de Testes Realizados'

END
   
   --EXEC sp_DadosPortugal

   
   GO


CREATE PROCEDURE sp_DadosGE 
AS 
BEGIN     
	SELECT Grupo_etario.GrupoEtario, COUNT(Pessoas.cod_GE) 
	AS 'Quantidade' FROM Pessoas INNER JOIN Grupo_etario ON Pessoas.cod_GE = Grupo_etario.cod_GE 
	GROUP BY GrupoEtario 
END

--EXEC sp_DadosGE

GO


CREATE PROCEDURE sp_DadosConcelhos
AS
BEGIN
    SELECT Concelhos.Concelho, COUNT(Pessoas.cod_Estado) AS 'Infetados' FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade 
    INNER JOIN Concelhos ON Cidades.cod_Concelho = Concelhos.cod_Concelho WHERE cod_Estado = 1 GROUP BY Concelho

END

--EXEC sp_DadosConcelhos

GO


CREATE PROCEDURE sp_Concelho @Concelho VARCHAR(50)
AS
BEGIN

    DECLARE @Ativos INT
    DECLARE @Recuperados INT
    DECLARE @Obitos INT
    DECLARE @Confirmados INT

    SET @Ativos = ( SELECT COUNT(Pessoas.cod_Estado) FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Concelhos ON Cidades.cod_Concelho = Concelhos.cod_Concelho WHERE Concelho = @Concelho AND cod_Estado = 1)
    SET @Recuperados = (SELECT COUNT(Pessoas.cod_Estado) FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Concelhos ON Cidades.cod_Concelho = Concelhos.cod_Concelho WHERE Concelho = @Concelho AND cod_Estado = 2)
    SET @Obitos = (SELECT COUNT(Pessoas.cod_Estado) FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Concelhos ON Cidades.cod_Concelho = Concelhos.cod_Concelho WHERE Concelho = @Concelho AND cod_Estado = 3)
    SET @Confirmados = (SELECT COUNT(Pessoas.cod_Estado) FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Concelhos ON Cidades.cod_Concelho = Concelhos.cod_Concelho WHERE Concelho = @Concelho)

    SELECT @Concelho AS 'Concelho', @Ativos AS 'Ativos', @Recuperados AS 'Recuperados', @Obitos AS 'Obitos', @Confirmados AS 'Confirmados' 
END

--EXEC sp_Concelho @Concelho = Lisboa

GO


CREATE PROCEDURE sp_ConcelhoCidades @Concelho VARCHAR(50)
AS
BEGIN
    SELECT @Concelho AS 'Concelho', Cidades.Cidade, COUNT(cod_Estado) AS 'Ativos' 
    FROM Pessoas 
    INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Concelhos ON Cidades.cod_Concelho = Concelhos.cod_Concelho
    WHERE cod_Estado = 1 AND Concelhos.Concelho = @Concelho
    GROUP BY Cidades.Cidade
END

--EXEC sp_ConcelhoCidades @Concelho = Lisboa

GO


CREATE PROCEDURE sp_TotalGenero 
AS 
BEGIN      
	SELECT Sexo, COUNT(CASE cod_Estado WHEN 1 THEN 1 ELSE NULL END) AS 'Ativos', 
	COUNT(CASE cod_Estado WHEN 2 THEN 1 ELSE NULL END) AS 'Recuperados', 
	COUNT(CASE cod_Estado WHEN 3 THEN 1 ELSE NULL END) AS 'Obitos',
	COUNT(cod_Estado) AS 'Confirmados'
	FROM Pessoas     
	GROUP BY Sexo  
END 
GO

--EXEC sp_TotalGenero


CREATE PROCEDURE sp_AtivosRegiao @Pais VARCHAR(50)
AS
BEGIN
 SELECT @Pais AS 'País', Regioes.Regiao, COUNT(cod_Estado) AS 'Ativos' 
    FROM Pessoas 
    INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais
    WHERE cod_Estado = 1 AND Paises.Pais = @Pais
    GROUP BY Regioes.Regiao
END

--EXEC sp_AtivosRegiao @Pais = Portugal

GO


CREATE PROCEDURE sp_RecuperadosRegiao @Pais VARCHAR(50)
AS
BEGIN
 SELECT @Pais AS 'País', Regioes.Regiao, COUNT(cod_Estado) AS 'Recuperados' 
    FROM Pessoas 
    INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais
    WHERE cod_Estado = 2 AND Paises.Pais = @Pais
    GROUP BY Regioes.Regiao
END

--EXEC sp_RecuperadosRegiao @Pais = Portugal

GO

CREATE PROCEDURE sp_ObitosRegiao @Pais VARCHAR(50)
AS
BEGIN
 SELECT @Pais AS 'País', Regioes.Regiao, COUNT(cod_Estado) AS 'Obitos' 
    FROM Pessoas 
    INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais
    WHERE cod_Estado = 3 AND Paises.Pais = @Pais
    GROUP BY Regioes.Regiao
END

--EXEC sp_ObitosRegiao @Pais = Portugal

GO


CREATE PROCEDURE sp_ConfirmadosRegiao @Pais VARCHAR(50)
AS
BEGIN
 SELECT @Pais AS 'País', Regioes.Regiao, COUNT(cod_Estado) AS 'Confirmados' 
    FROM Pessoas 
    INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais
    WHERE Paises.Pais = @Pais
    GROUP BY Regioes.Regiao
END

--EXEC sp_ConfirmadosRegiao @Pais = Portugal





GO

CREATE PROCEDURE sp_MortesPorIdade
AS
BEGIN
	SELECT Grupo_etario.GrupoEtario, COUNT(Pessoas.cod_GE) 
	AS 'Óbitos' FROM Pessoas INNER JOIN Grupo_etario ON Pessoas.cod_GE = Grupo_etario.cod_GE
	WHERE cod_Estado = 3
	GROUP BY GrupoEtario 
END

--EXEC sp_MortesPorIdade

GO


CREATE PROCEDURE sp_AtivosPorPais
AS
BEGIN
    SELECT Paises.Pais, COUNT(Pessoas.cod_Estado) AS 'Ativos' FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade 
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais  WHERE cod_Estado =1 GROUP BY Pais
END

--EXEC sp_AtivosPorPais

GO

CREATE PROCEDURE sp_RecuperadosPorPais
AS
BEGIN
    SELECT Paises.Pais, COUNT(Pessoas.cod_Estado) AS 'Recuperados' FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade 
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 2 GROUP BY Pais
END

--EXEC sp_RecuperadosPorPais

GO

CREATE PROCEDURE sp_ObitosPorPais
AS
BEGIN
    SELECT Paises.Pais, COUNT(Pessoas.cod_Estado) AS 'Obitos' FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade 
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 3 GROUP BY Pais
END

--EXEC sp_ObitosPorPais

GO

CREATE PROCEDURE sp_ConfirmadosPorPais
AS
BEGIN
    SELECT Paises.Pais, COUNT(Pessoas.cod_Estado) AS 'Confirmados' FROM Pessoas INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade 
    INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais GROUP BY Pais
END

--EXEC sp_ConfirmadosPorPais
GO

GO

EXEC sp_addrole 'db_Administrador'
GO
EXEC sp_addrole 'db_Concelho'
GO
EXEC sp_addrole 'db_Visitante'
GO

CREATE USER Sines WITHOUT LOGIN
GO
CREATE USER DGS WITHOUT LOGIN
GO

EXEC sp_addrolemember 'db_owner', 'db_Administrador'
GO
EXEC sp_addrolemember 'db_Concelho', 'Sines'
GO
EXEC sp_addrolemember 'db_Visitante', 'DGS'
GO

GRANT EXEC ON sp_Concelho to db_Concelho
GO
GRANT EXEC ON sp_ConcelhoCidades to db_Concelho
GO
GRANT EXEC ON sp_DadosPortugal to db_Visitante
GO
GRANT EXEC ON sp_DadosConcelhos to db_Visitante
GO
GRANT EXEC ON sp_Concelho to db_Visitante
GO
GRANT EXEC ON sp_ConcelhoCidades to db_Visitante
GO
GRANT EXEC ON sp_DadosGE to db_Visitante
GO
GRANT EXEC ON sp_TotalGenero to db_Visitante
GO
GRANT EXEC ON sp_AtivosRegiao to db_Visitante
GO
GRANT EXEC ON sp_RecuperadosRegiao to db_Visitante
GO
GRANT EXEC ON sp_ObitosRegiao to db_Visitante
GO
GRANT EXEC on sp_ConfirmadosRegiao to db_Visitante
GO
GRANT EXEC ON sp_AtivosPorPais to db_Visitante
GO
GRANT EXEC ON sp_RecuperadosPorPais to db_Visitante
GO
GRANT EXEC ON sp_ObitosPorPais to db_Visitante
GO
GRANT EXEC ON sp_ConfirmadosPorPais to db_Visitante