﻿CREATE DATABASE bdEstoque
GO
USE bdEstoque

----------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE'S

CREATE TABLE tbCliente(
    codCliente INT PRIMARY KEY IDENTITY(1,1)
    ,nomeCliente VARCHAR(70) NOT NULL
    ,cpfCliente VARCHAR(15) NOT NULL
    ,emailCliente VARCHAR (90)
    ,sexoCliente VARCHAR (2)
    ,dataNascimentoCliente SMALLDATETIME NOT NULL
);

CREATE TABLE tbVenda(
    codVenda INT PRIMARY KEY IDENTITY (1,1)
    ,dataVenda DATE
    ,valorTotalVenda MONEY
    ,codCliente INT FOREIGN KEY REFERENCES tbCliente(codCliente)
);

CREATE TABLE tbFabricante(
    codFabricante INT PRIMARY KEY IDENTITY (1,1)
    ,nomeFabricante VARCHAR (90)
);

CREATE TABLE tbFornecedor(
    codFornecedor INT PRIMARY KEY IDENTITY (1,1)
    ,nomeFornecedor VARCHAR (90)
    ,contatoFornecedor VARCHAR (30)
);
GO

CREATE TABLE tbProduto(
    codProduto INT PRIMARY KEY IDENTITY (1,1)
    ,descricaoProduto VARCHAR (90)
    ,valorProduto MONEY
    ,quantidadeProduto INT 
    ,codFabricante INT FOREIGN KEY REFERENCES tbFabricante(codFabricante)
    ,codFornecedor INT FOREIGN KEY REFERENCES tbFornecedor(codFornecedor)
);
GO

CREATE TABLE tbItensVenda(
    codItensVenda INT PRIMARY KEY IDENTITY(1,1)
    ,codVenda INT FOREIGN KEY REFERENCES tbVenda(codVenda)
    ,codProduto INT FOREIGN KEY REFERENCES tbProduto(codProduto)
    ,quantidadeItensVenda INT
    ,subTotalItensVenda MONEY
);

CREATE TABLE tbEntradaProduto(
	codEntradaProduto INT PRIMARY KEY IDENTITY(1,1)
	,dataEntradaProduto DATE
	,codProduto INT FOREIGN KEY REFERENCES tbProduto(codProduto)
	,quantidadeEntradaProduto INT
);

CREATE TABLE tbSaidaProduto(
	codSaidaProduto INT PRIMARY KEY IDENTITY(1,1)
	,dataSaidaProduto DATE
	,codProduto INT FOREIGN KEY REFERENCES tbProduto(codProduto)
	,quantidadeSaidaProduto INT
);
GO
