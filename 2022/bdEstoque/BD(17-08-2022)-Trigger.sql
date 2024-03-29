USE bdEstoque

----------------------------------------------------------------------------------------------------------------------------------------------
-- 1) Criar uma trigger que, ao ser feita uma venda (Insert na tabela tbItensVenda), todos os produtos vendidos tenham sua quantidade atualizada na tabela tbProduto. 

CREATE TRIGGER tgDiminuiQuantidadeProduto 
	ON tbItensVenda AFTER INSERT 
	AS BEGIN
		DECLARE @codProduto INT, @quantidadeProduto INT, @quantidadeDisponivel INT
		
		SET @codProduto = (
			SELECT codProduto FROM INSERTED
		);

		SET @quantidadeProduto = (
			SELECT quantidadeItensVenda FROM INSERTED
		);

		SET @quantidadeDisponivel = (
			SELECT quantidadeProduto FROM tbProduto 
				WHERE codProduto = @codProduto
		);

		IF (@quantidadeProduto <= @quantidadeDisponivel) BEGIN
			UPDATE tbProduto SET quantidadeProduto = quantidadeProduto - @quantidadeProduto
				WHERE codProduto = @codProduto
		END
		ELSE BEGIN
			PRINT('QUANTIDADE INDISPONIVEL!');
		END
	END

----------------------------------------------------------------------------------------------------------------------------------------------
/* 2)
Criar uma trigger que, quando for inserida uma nova entrada de produtos
na tbEntradaProduto, a quantidade desse produto seja atualizada e aumentada na tabela tbProduto;
*/

CREATE TRIGGER tgAumentaQuantidadeProduto
	ON tbEntradaProduto AFTER INSERT
	AS BEGIN
		DECLARE @quantidadeProduto INT, @codProduto INT

		SET @codProduto = (SELECT codProduto FROM INSERTED);
		SET @quantidadeProduto = (SELECT quantidadeEntradaProduto FROM INSERTED);

		UPDATE tbProduto SET quantidadeProduto = quantidadeProduto + @quantidadeProduto
			WHERE codProduto = @codProduto
	END
----------------------------------------------------------------------------------------------------------------------------------------------
-- 3) Criar uma trigger que, quando for feita uma venda de um determinado produto, seja feito um Insert na tbSaidaProduto.

CREATE TRIGGER tgRegistraSaidaProduto
	ON tbVenda AFTER INSERT
	AS BEGIN
		DECLARE @codVenda INT, @dataVenda DATE, @quantidadeProduto INT, @codProduto INT

		SET @codVenda = (SELECT codVenda FROM INSERTED);

		SET @dataVenda = (SELECT dataVenda FROM INSERTED);

		SET @codProduto = (
			SELECT tbItensVenda.codProduto FROM tbItensVenda
				INNER JOIN tbVenda ON tbVenda.codVenda = @codVenda
				INNER JOIN tbProduto ON tbProduto.codProduto = tbItensVenda.codProduto

		);

		SET @quantidadeProduto = (
			SELECT quantidadeItensVenda FROM tbItensVenda
				INNER JOIN tbVenda ON tbVenda.codVenda = @codVenda
				INNER JOIN tbProduto ON tbProduto.codProduto = @codProduto
		);

		INSERT INTO tbSaidaProduto(dataSaidaProduto, codProduto, quantidadeSaidaProduto)
			VALUES (@dataVenda, @codProduto, @quantidadeProduto);
	END
