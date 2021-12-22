USE COVID19
GO

-------------------------------- TRIGGER DADOS 24H --------------------------------

CREATE TRIGGER tr_Dados24h
ON dbo.Pessoas
AFTER UPDATE, INSERT
AS
   DECLARE @DataAnterior DATETIME
   SET @DataAnterior = DATEADD(HOUR,-24,SYSDATETIME())
   UPDATE dbo.Pessoas
   SET Data_mod = SYSDATETIME()
   FROM Inserted i
   WHERE dbo.Pessoas.cod_Pessoa = i.cod_Pessoa
   UPDATE dbo.Dados24h
   SET Ativos = (SELECT COUNT(cod_Estado) FROM Pessoas
   WHERE cod_Estado = 1 AND Data_mod BETWEEN @DataAnterior AND SYSDATETIME()),
   Recuperados = (SELECT COUNT(cod_Estado) FROM Pessoas 
   WHERE cod_Estado = 2 AND Data_mod BETWEEN @DataAnterior AND SYSDATETIME()),
   Obitos = (SELECT COUNT(cod_Estado) FROM Pessoas 
   WHERE cod_Estado = 3 AND Data_mod BETWEEN @DataAnterior AND SYSDATETIME()),
   Confirmados = (SELECT COUNT(cod_Estado) FROM Pessoas 
   WHERE Data_mod BETWEEN @DataAnterior AND SYSDATETIME()),
   Total_testes = (SELECT SUM(Nr_testes) FROM Pessoas
   WHERE Data_mod BETWEEN @DataAnterior AND SYSDATETIME())

GO
-------------------------------- TRIGGER DADOS TOTAL --------------------------------

CREATE TRIGGER tr_DadosTotal
ON dbo.Pessoas
AFTER UPDATE, INSERT
AS
   UPDATE dbo.DadosTotal
   SET Ativos = (SELECT COUNT(cod_Estado) FROM Pessoas
   WHERE cod_Estado = 1),
   Recuperados = (SELECT COUNT(cod_Estado) FROM Pessoas 
   WHERE cod_Estado = 2),
   Obitos = (SELECT COUNT(cod_Estado) FROM Pessoas 
   WHERE cod_Estado = 3),
   Confirmados = (SELECT COUNT(cod_Estado) FROM Pessoas),
   Total_testes = (SELECT SUM(Nr_testes) FROM Pessoas)

GO

-------------------------------- TRIGGER ALERTA 1% POPULAÇÃO INFETADA --------------------------------

CREATE TRIGGER tr_AlertaPopulacao
ON dbo.Pessoas
AFTER UPDATE, INSERT
AS
   DECLARE @PopulacaoPortugal DECIMAL(15,5)
   DECLARE @PopulacaoEspanha DECIMAL(15,5)
   DECLARE @PopulacaoTESTE DECIMAL(15,10)
   DECLARE @AtivosPortugal DECIMAL(15,10)
   DECLARE @AtivosEspanha DECIMAL(15,10)
   DECLARE @AtivosTESTE DECIMAL(15,10)

   SET @PopulacaoPortugal = (SELECT Populacao FROM Paises WHERE cod_Pais = 170)
   SET @PopulacaoEspanha = (SELECT Populacao FROM Paises WHERE cod_Pais = 62)
   SET @PopulacaoTESTE = (SELECT Populacao FROM Paises WHERE cod_Pais = 231)

   SET @AtivosPortugal = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 1 AND Paises.cod_Pais = 170)
   SET @AtivosEspanha = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 1 AND Paises.cod_Pais = 62)
   SET @AtivosTESTE = (SELECT COUNT(cod_Estado) FROM Pessoas 
   INNER JOIN Cidades ON Pessoas.cod_Cidade = Cidades.cod_Cidade INNER JOIN Regioes ON Cidades.cod_Regiao = Regioes.cod_Regiao
   INNER JOIN Paises ON Regioes.cod_Pais = Paises.cod_Pais WHERE cod_Estado = 1 AND Paises.cod_Pais = 231)

   IF @AtivosPortugal / @PopulacaoPortugal * 100 >= 1
   BEGIN
		PRINT 'Chegou a 1% da população infetada de Portugal'
   END

    IF @AtivosEspanha / @PopulacaoEspanha * 100 >= 1
   BEGIN
		PRINT 'Chegou a 1% da população infetada de Espanha'
   END

    IF @AtivosTESTE / @PopulacaoTESTE * 100 >= 1
   BEGIN
		PRINT 'Chegou a 1% da população infetada do pais TESTE'
   END

GO

-------------------------------- TRIGGER SEGURANÇA --------------------------------

CREATE TRIGGER tr_Seguranca
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    PRINT 'Não pode apagar ou alterar tabelas'
    ROLLBACK
END
GO

